-- ACCOUNTS
INSERT INTO Accounts(id, nature, name)
VALUES ('10', 'debit', 'Assets');

SELECT * FROM Accounts;

-- ENTRIES
INSERT INTO Entries(details)
VALUES ('Stock');

SELECT * FROM Entries;

-- DIARY
INSERT INTO Diary(entry_id, account_id, debit)
VALUES (1, '10', 100.00);

SELECT * FROM Diary;

-- DROP
DROP TABLE Diary;
DROP TABLE Entries;
DROP TABLE Accounts;
