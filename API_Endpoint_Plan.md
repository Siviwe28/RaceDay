CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('organiser', 'participant')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    date TIMESTAMP NOT NULL,
    location VARCHAR(255) NOT NULL,
    distance VARCHAR(50) NOT NULL,
    event_type VARCHAR(20) NOT NULL CHECK (event_type IN ('run', 'walk', 'cycle')),
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'in_progress', 'completed', 'cancelled')),
    organiser_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age_group VARCHAR(50),
    distance VARCHAR(50),
    event_id INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(event_id, name)
);

CREATE TABLE enrolments (
    id SERIAL PRIMARY KEY,
    participant_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    event_id INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    enrolment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'attended')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(participant_id, event_id, category_id)
);

CREATE TABLE results (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE,
    category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    finish_time TIME,
    position INTEGER,
    dnf BOOLEAN DEFAULT FALSE,
    dns BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(event_id, user_id)
);

CREATE INDEX idx_events_date ON events(date);
CREATE INDEX idx_events_status ON events(status);
CREATE INDEX idx_events_organiser ON events(organiser_id);
CREATE INDEX idx_categories_event ON categories(event_id);
CREATE INDEX idx_enrolments_participant ON enrolments(participant_id);
CREATE INDEX idx_enrolments_event ON enrolments(event_id);
CREATE INDEX idx_enrolments_category ON enrolments(category_id);
CREATE INDEX idx_results_event ON results(event_id);
CREATE INDEX idx_results_category ON results(category_id);
CREATE INDEX idx_results_user ON results(user_id);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_enrolments_updated_at BEFORE UPDATE ON enrolments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_results_updated_at BEFORE UPDATE ON results
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

INSERT INTO users (email, password_hash, role) VALUES
('organiser@raceday.com', 'hashed_password_1', 'organiser'),
('participant1@raceday.com', 'hashed_password_2', 'participant'),
('participant2@raceday.com', 'hashed_password_3', 'participant');

INSERT INTO events (name, description, date, location, distance, event_type, status, organiser_id) VALUES
('City Marathon 2026', 'Annual city marathon event', '2026-09-15 07:00:00', 'City Center', '42.2km', 'run', 'published', 1),
('Coastal Walk', 'Scenic coastal walking event', '2026-10-01 08:00:00', 'Beach Road', '10km', 'walk', 'draft', 1),
('Mountain Cycle', 'Challenging mountain bike race', '2026-11-10 06:00:00', 'Mountain Ridge', '21.1km', 'cycle', 'published', 1);

INSERT INTO categories (name, age_group, distance, event_id) VALUES
('Under 20', 'U20', '5km', 1),
('Senior', '18-39', '42.2km', 1),
('Masters', '40+', '42.2km', 1),
('10km Walk', NULL, '10km', 2),
('21km Cycle', NULL, '21.1km', 3);

INSERT INTO enrolments (participant_id, event_id, category_id, status) VALUES
(2, 1, 2, 'confirmed'),
(3, 1, 1, 'pending'),
(2, 3, 5, 'confirmed');

INSERT INTO results (event_id, category_id, user_id, finish_time, position) VALUES
(1, 2, 2, '03:45:30', 1),
(1, 1, 3, '00:25:00', 1);

SELECT * FROM events 
WHERE event_type = 'run' 
  AND date >= CURRENT_DATE 
  AND status = 'published'
ORDER BY date;

SELECT e.*, 
       json_agg(c.*) as categories
FROM events e
LEFT JOIN categories c ON e.id = c.event_id
WHERE e.id = 1
GROUP BY e.id;

SELECT * FROM events 
WHERE date >= CURRENT_DATE 
  AND status IN ('published', 'in_progress')
ORDER BY date;

SELECT u.id, u.email, c.name as category, en.status, en.enrolment_date
FROM enrolments en
JOIN users u ON en.participant_id = u.id
JOIN categories c ON en.category_id = c.id
WHERE en.event_id = 1;

SELECT * FROM categories WHERE event_id = 1;

SELECT e.*, ev.name as event_name, c.name as category_name
FROM enrolments e
JOIN events ev ON e.event_id = ev.id
JOIN categories c ON e.category_id = c.id
WHERE e.participant_id = 2;

SELECT r.*, u.email, c.name as category
FROM results r
JOIN users u ON r.user_id = u.id
JOIN categories c ON r.category_id = c.id
WHERE r.event_id = 1
ORDER BY r.position;

SELECT COUNT(*) 
FROM enrolments 
WHERE participant_id = 2 
  AND event_id = 1 
  AND category_id = 2
  AND status != 'cancelled';

UPDATE events SET status = 'cancelled' WHERE id = 1;

SELECT 
    e.id,
    e.name,
    COUNT(DISTINCT en.participant_id) as total_participants,
    COUNT(DISTINCT c.id) as total_categories,
    COUNT(r.id) as total_results
FROM events e
LEFT JOIN enrolments en ON e.id = en.event_id AND en.status != 'cancelled'
LEFT JOIN categories c ON e.id = c.event_id
LEFT JOIN results r ON e.id = r.event_id
GROUP BY e.id;
