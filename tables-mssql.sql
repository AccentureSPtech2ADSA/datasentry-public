CREATE DATABASE datasentry;
GO;
USE datasentry;
GO;
CREATE TABLE Hospital(
	_idHospital INT PRIMARY KEY IDENTITY(1,1),
	cnpj CHAR(14),
	cep CHAR(8),
	numberAddress VARCHAR(10),
	complement VARCHAR(50),
	fantasyName VARCHAR(50),
	unit VARCHAR(50),
	corporateName VARCHAR(50),
	createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP 
);
GO;
CREATE TABLE UserHospital(
	_idUserHospital INT PRIMARY KEY IDENTITY(1,1),
	name VARCHAR(100),
	email VARCHAR(100),
	password VARBINARY(150),
	contactPhone CHAR(13),
	fkHospital INT NOT NULL,
	FOREIGN KEY (fkHospital) REFERENCES Hospital(_idHospital),
	fkManager INT,
	FOREIGN KEY (fkManager) REFERENCES UserHospital(_idUserHospital),
	createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP 
);
GO;
CREATE TABLE Server(
	_serialServer VARCHAR(50) PRIMARY KEY, -- senão pegar serial vamos pegar outro dado único do PC
	isActive CHAR(1),
	description VARCHAR(100),
	fkHospital INT NOT NULL,
	FOREIGN KEY (fkHospital) REFERENCES Hospital(_idHospital),
	createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP 
);
GO;

CREATE TABLE Process(
	_idProcess INT PRIMARY KEY IDENTITY(1,1), -- talvez vire o PID
	name VARCHAR(50),
	createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP 
);
GO;
CREATE TABLE ComponentType( 
	_idComponentType INT PRIMARY KEY IDENTITY(1,1),
	description VARCHAR(25), 
	measuramentUnit VARCHAR(8),
	createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP 
);
GO;
CREATE TABLE ComponentServer(
	_idComponentServer INT IDENTITY(1,1),
	serial VARCHAR(60),
	model VARCHAR(60),
	brand VARCHAR(50),
	maxUse DECIMAL(10,2),
	fkServer VARCHAR(50) NOT NULL,
	FOREIGN KEY (fkServer) REFERENCES Server(_serialServer),
	fkComponentType INT NOT NULL,
	FOREIGN KEY (fkComponentType) REFERENCES ComponentType(_idComponentType),
	createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (_idComponentServer, fkComponentType)
);
GO;
CREATE TABLE LogComponentPerProcess(
	_idLogComponentPerProcess INT IDENTITY(1,1),
	usageComponent decimal(10,2),
	createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
	fkProcess INT,
	FOREIGN KEY (fkProcess) REFERENCES Process(_idProcess),
	fkComponentType INT,
	fkComponentServer INT,
	FOREIGN KEY (fkComponentServer, fkComponentType)
	REFERENCES ComponentServer(_idComponentServer, fkComponentType),
	PRIMARY KEY (_idLogComponentPerProcess, fkComponentServer, fkComponentType, fkProcess)
);
GO;
