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
Ward_2021 TINYINT NOT NULL FOREIGN KEY REFERENCES Ward(WardID),
Ward_2017 TINYINT NOT NULL FOREIGN KEY REFERENCES Ward(WardID)
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
VotingStationID SMALLINT NOT NULL IDENTITY(1,1) PRIMARY KEY,
VotingStationNumber SMALLINT,
VotingStationName VARCHAR(70),
EnumeratedElectors SMALLINT,
PercentVoterTurnout DECIMAL(3,2),
VotingStationTypeID TINYINT NOT NULL FOREIGN KEY REFERENCES Voting_Station_Type(VotingStationTypeID),
Ward_2021 TINYINT NOT NULL FOREIGN KEY REFERENCES Ward(WardID),
Ward_2017 TINYINT NOT NULL FOREIGN KEY REFERENCES Ward(WardID)
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
SELECT DISTINCT Ward_2021
FROM MasterTable;

INSERT INTO Candidate_Status(CandidateStatusID, CandidateStatus)
SELECT DISTINCT CandidateStatusID, CandidateStatus
FROM MasterTable;

INSERT INTO Electoral_Status(ElectoralStatusID, ElectoralStatus)
SELECT DISTINCT ElectoralStatusID, ElectoralStatus
FROM MasterTable;

INSERT INTO Office_Type(OfficeTypeID, OfficeType)
SELECT DISTINCT OfficeTypeID, OfficeType
FROM MasterTable;

INSERT INTO Voting_Station_Type(VotingStationTypeID, VotingStationType)
SELECT DISTINCT VotingStationTypeID,VotingStationType
FROM MasterTable;

INSERT INTO Community_Demographics(CommunityID, CommunityName, CommunityPopulation, TotalMale, TotalFemale,
TotalAge20_29, TotalAge30_39, TotalAge40_49, TotalAge50_59, TotalAge60_69, TotalAge70_79, TotalAgeMoreThan80,
TotalIncomeLessThan59K, TotalIncome60K_99999, TotalIncome100K_149999, TotalIncome150K_199999, TotalIncomeMoreThan200K,
TotalCitizens, TotalNonCitizens, TotalFamiliesWChildren, TotalFamiliesWOChildren, TotalHomeOwners, TotalRenters, Ward_2021, Ward_2017)
SELECT DISTINCT CommunityID, CommunityName, CommunityPopulation, TotalMale, TotalFemale,
TotalAge20_29, TotalAge30_39, TotalAge40_49, TotalAge50_59, TotalAge60_69, TotalAge70_79, TotalAgeMoreThan80,
TotalIncomeLessThan59K, TotalIncome60K_99999, TotalIncome100K_149999, TotalIncome150K_199999, TotalIncomeMoreThan200K,
TotalCitizens, TotalNonCitizens, TotalFamiliesWChildren, TotalFamiliesWOChildren, TotalHomeOwners, TotalRenters, Ward_2021, Ward_2017
FROM MasterTable;

INSERT INTO Candidate(CandidateID, CandidateName, CandidateStatusID, ElectoralStatusID, OfficeTypeID)
SELECT DISTINCT CandidateID, CandidateName, CandidateStatusID, ElectoralStatusID, OfficeTypeID
FROM MasterTable;

INSERT INTO Voting_Station(VotingStationNumber, VotingStationName, EnumeratedElectors, PercentVoterTurnout, VotingStationTypeID, Ward_2021, Ward_2017)
SELECT DISTINCT VotingStationNumber, VotingStationName, TotalEnumeratedElectors, PercentVoterTurnout, VotingStationTypeID, Ward_2021, Ward_2017
FROM MasterTable;

-- populate bridge table --

INSERT INTO Community_Candidate_Station(CommunityID, CandidateID, VotingStationID, Votes)
SELECT MT.CommunityID, MT.CandidateID, VS.VotingStationID, MT.Votes
FROM MasterTable as MT
JOIN Voting_Station as VS
ON MT.VotingStationName = VS.VotingStationName;

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