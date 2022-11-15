-- DROP SCHEMA dbo;

CREATE SCHEMA dbo;
-- datasentry.dbo.ComponentType definition

-- Drop table

-- DROP TABLE datasentry.dbo.ComponentType;

CREATE TABLE ComponentType (
	[_idComponentType] int IDENTITY(1,1) NOT NULL,
	description varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	measuramentUnit varchar(5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	createdAt datetime DEFAULT getdate() NULL,
	updatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Componen__37C058D58D4F0459 PRIMARY KEY ([_idComponentType])
);


-- datasentry.dbo.Hospital definition

-- Drop table

-- DROP TABLE datasentry.dbo.Hospital;

CREATE TABLE Hospital (
	[_idHospital] int IDENTITY(1,1) NOT NULL,
	cnpj char(14) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	cep char(8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	numberAddress varchar(10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	complement varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fantasyName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	unit varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	corporateName varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	createdAt datetime DEFAULT getdate() NULL,
	updatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Hospital__3191C4651C725789 PRIMARY KEY ([_idHospital])
);


-- datasentry.dbo.Process definition

-- Drop table

-- DROP TABLE datasentry.dbo.Process;

CREATE TABLE Process (
	[_idProcess] int IDENTITY(1,1) NOT NULL,
	name varchar(25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	createdAt datetime DEFAULT getdate() NULL,
	updatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Process__9492243694764CE9 PRIMARY KEY ([_idProcess])
);


-- datasentry.dbo.Server definition

-- Drop table

-- DROP TABLE datasentry.dbo.Server;

CREATE TABLE Server (
	[_serialServer] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	isActive char(1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	description varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fkHospital int NOT NULL,
	createdAt datetime DEFAULT getdate() NULL,
	updatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Server__F59EF81ED7BFD8AC PRIMARY KEY ([_serialServer]),
	CONSTRAINT FK__Server__fkHospit__4F47C5E3 FOREIGN KEY (fkHospital) REFERENCES Hospital([_idHospital])
);


-- datasentry.dbo.UserHospital definition

-- Drop table

-- DROP TABLE datasentry.dbo.UserHospital;

CREATE TABLE UserHospital (
	[_idUserHospital] int IDENTITY(1,1) NOT NULL,
	name varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	password varbinary(150) NULL,
	contactPhone char(13) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	fkHospital int NOT NULL,
	fkManager int NULL,
	createdAt datetime DEFAULT getdate() NULL,
	updatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__UserHosp__963EB9DD311FB1F9 PRIMARY KEY ([_idUserHospital]),
	CONSTRAINT FK__UserHospi__fkHos__498EEC8D FOREIGN KEY (fkHospital) REFERENCES Hospital([_idHospital]),
	CONSTRAINT FK__UserHospi__fkMan__4A8310C6 FOREIGN KEY (fkManager) REFERENCES UserHospital([_idUserHospital])
);


-- datasentry.dbo.ComponentServer definition

-- Drop table

-- DROP TABLE datasentry.dbo.ComponentServer;

CREATE TABLE ComponentServer (
	[_idComponentServer] int IDENTITY(1,1) NOT NULL,
	serial varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	model varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	brand varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	maxUse decimal(10,2) NULL,
	fkServer varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	fkComponentType int NOT NULL,
	createdAt datetime DEFAULT getdate() NULL,
	updatedAt datetime DEFAULT getdate() NULL,
	CONSTRAINT PK__Componen__1E87A23884F02A98 PRIMARY KEY ([_idComponentServer],fkComponentType),
	CONSTRAINT FK__Component__fkCom__7849DB76 FOREIGN KEY (fkComponentType) REFERENCES ComponentType([_idComponentType]),
	CONSTRAINT FK__Component__fkSer__7755B73D FOREIGN KEY (fkServer) REFERENCES Server([_serialServer])
);


-- datasentry.dbo.LogComponentPerProcess definition

-- Drop table

-- DROP TABLE datasentry.dbo.LogComponentPerProcess;

CREATE TABLE LogComponentPerProcess (
	[_idLogComponentPerProcess] int IDENTITY(1,1) NOT NULL,
	usageComponent decimal(10,2) NULL,
	createdAt datetime DEFAULT getdate() NULL,
	updatedAt datetime DEFAULT getdate() NULL,
	fkProcess int NOT NULL,
	fkComponentType int NOT NULL,
	fkComponentServer int NOT NULL,
	CONSTRAINT PK__LogCompo__40E184D17E0E322A PRIMARY KEY ([_idLogComponentPerProcess],fkComponentServer,fkComponentType,fkProcess),
	CONSTRAINT FK__LogCompon__fkPro__7EF6D905 FOREIGN KEY (fkProcess) REFERENCES Process([_idProcess]),
	CONSTRAINT FK__LogComponentPerP__7FEAFD3E FOREIGN KEY (fkComponentServer,fkComponentType) REFERENCES ComponentServer([_idComponentServer],fkComponentType)
);
