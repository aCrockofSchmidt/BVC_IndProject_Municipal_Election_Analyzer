USE Municipal_Election_Analysis

-- master table viewing and deletion --

SELECT * FROM MasterTable;
DROP TABLE MasterTable;

-- creation of database tables --

CREATE TABLE Ward
(
WardID TINYINT NOT NULL PRIMARY KEY
);

CREATE TABLE Candidate_Status
(
CandidateStatusID TINYINT NOT NULL PRIMARY KEY,
CandidateStatus VARCHAR(13)
);

CREATE TABLE Electoral_Status
(
ElectoralStatusID TINYINT NOT NULL PRIMARY KEY,
ElectoralStatus VARCHAR(13)
);

CREATE TABLE Office_Type
(
OfficeTypeID TINYINT NOT NULL PRIMARY KEY,
OfficeType VARCHAR(23)
);

CREATE TABLE Voting_Station_Type
(
VotingStationTypeID TINYINT NOT NULL PRIMARY KEY,
VotingStationType VARCHAR(7)
);

CREATE TABLE Community_Demographics
(
CommunityID TINYINT NOT NULL PRIMARY KEY,
CommunityName VARCHAR(50),
CommunityPopulation INT,
TotalMale SMALLINT,
TotalFemale SMALLINT,
TotalAge20_29 SMALLINT,
TotalAge30_39 SMALLINT,
TotalAge40_49 SMALLINT,
TotalAge50_59 SMALLINT,
TotalAge60_69 SMALLINT,
TotalAge70_79 SMALLINT,
TotalAgeMoreThan80 SMALLINT,
TotalIncomeLessThan59K SMALLINT,
TotalIncome60K_99999 SMALLINT,
TotalIncome100K_149999 SMALLINT,
TotalIncome150K_199999 SMALLINT,
TotalIncomeMoreThan200K SMALLINT,
TotalCitizens INT,
TotalNonCitizens SMALLINT,
TotalFamiliesWChildren SMALLINT,
TotalFamiliesWOChildren SMALLINT,
TotalHomeOwners SMALLINT,
TotalRenters SMALLINT,
NewWard TINYINT NOT NULL FOREIGN KEY REFERENCES Ward(WardID),
OldWard TINYINT NOT NULL FOREIGN KEY REFERENCES Ward(WardID)
);

CREATE TABLE Candidate
(
CandidateID TINYINT NOT NULL PRIMARY KEY,
CandidateName VARCHAR(50),
CandidateStatusID TINYINT NOT NULL FOREIGN KEY REFERENCES Candidate_Status(CandidateStatusID),
ElectoralStatusID TINYINT NOT NULL FOREIGN KEY REFERENCES Electoral_Status(ElectoralStatusID),
OfficeTypeID TINYINT NOT NULL FOREIGN KEY REFERENCES Office_Type(OfficeTypeID)
);

CREATE TABLE Voting_Station
(
VotingStationID SMALLINT NOT NULL PRIMARY KEY,
VotingStationName VARCHAR(70),
TotalEnumeratedElectors SMALLINT,
PercentVoterTurnout DECIMAL(3,2),
VotingStationTypeID TINYINT NOT NULL FOREIGN KEY REFERENCES Voting_Station_Type(VotingStationTypeID),
NewWard TINYINT NOT NULL FOREIGN KEY REFERENCES Ward(WardID),
OldWard TINYINT NOT NULL FOREIGN KEY REFERENCES Ward(WardID)
);

CREATE TABLE Community_Candidate_Station
(
CommunityID TINYINT NOT NULL FOREIGN KEY REFERENCES Community_Demographics(CommunityID),
CandidateID TINYINT NOT NULL FOREIGN KEY REFERENCES Candidate(CandidateID),
VotingStationID SMALLINT NOT NULL FOREIGN KEY REFERENCES Voting_Station(VotingStationID),
PRIMARY KEY (CommunityID, CandidateID, VotingStationID),
Votes SMALLINT
);

-- populate database tables from master table --

INSERT INTO Ward(WardID)
SELECT DISTINCT NewWard
FROM MasterTable;

-- display contents of database tables --

SELECT * FROM Ward;
SELECT * FROM Candidate_Status;
SELECT * FROM Electoral_Status;
SELECT * FROM Office_Type;
SELECT * FROM Voting_Station_Type;
SELECT * FROM Community_Demographics;
SELECT * FROM Candidate;
SELECT * FROM Voting_Station;
SELECT * FROM Community_Candidate_Station;

-- deletion of database tables --

DROP TABLE Community_Candidate_Station;
DROP TABLE Voting_Station;
DROP TABLE Candidate;
DROP TABLE Community_Demographics;
DROP TABLE Ward;
DROP TABLE Candidate_Status;
DROP TABLE Electoral_Status;
DROP TABLE Office_Type;
DROP TABLE Voting_Station_Type;
