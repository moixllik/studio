PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS Accounts (
    id TEXT UNIQUE,
    nature TEXT NOT NULL,
    name TEXT NOT NULL,
    details TEXT
);

CREATE TABLE IF NOT EXISTS Entries (
    id INTEGER PRIMARY KEY,
    datetime TEXT DEFAULT current_timestamp,
    details TEXT
);

CREATE TABLE IF NOT EXISTS Diary (
    entry_id INTEGER,
    account_id TEXT,
    nobit NUMBER DEFAULT 0,
    debit NUMBER DEFAULT 0,
    credit NUMBER DEFAULT 0,
    details TEXT,
    FOREIGN KEY (entry_id) REFERENCES Entries(id),
    FOREIGN KEY (account_id) REFERENCES Accounts(id)
);

SELECT name as 'Tables' FROM sqlite_master WHERE type='table';
