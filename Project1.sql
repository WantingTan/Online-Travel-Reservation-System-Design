create database Database_Project1;
use Database_Project1;

create table Customer(
    LastName            CHAR(35),
    FirstName           CHAR(35),
    Address             CHAR(35),
    City                CHAR(35),
    State               CHAR(35),
    ZipCode             CHAR(35),
    Telephone           CHAR(15),
    Email               CHAR(255),
    AccountNumber       INTEGER,
    AccountCreationDate DATETIME,
    CreditCardNumber    CHAR(16),
    PRIMARY KEY(AccountNumber),
    CONSTRAINT CCardRange CHECK ( CreditCardNumber LIKE '%[0-9]%')
);
   
CREATE TABLE Preferences (
    AccountNumber   INTEGER,
    PreferredSeat   ENUM('aisle', 'window', 'business', 'first', 'economy'),
    PreferredMeal   ENUM('beef & rice', 'chicken & noodle', 'pizza'),
    FOREIGN KEY(AccountNumber) REFERENCES Customer(AccountNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    PRIMARY KEY(AccountNumber)
);

CREATE TABLE Reservation (
    ReservationNumber         INTEGER,
    DateOfTravel              DATETIME,
    BookingFee                INTEGER,
    FareRestriction           CHAR(60),
    PassengerNumber           INTEGER,
    TotalFare                 INTEGER,
	CustomerAcc               INTEGER,
    EmployeeNumber            INTEGER,
    FOREIGN KEY ( EmployeeNumber) REFERENCES Manager(EmployeeNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (CustomerAcc) REFERENCES Customer(AccountNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    PRIMARY KEY (ReservationNumber),
    CONSTRAINT FeeLessThanFare CHECK (BookingFee < TotalFare)
); 

CREATE TABLE Leg (
    Id                    INTEGER,
    StopId1              char(3),
    StopId2              char(3),
    FlightNumber        INTEGER,
    ReservationNumber  INTEGER,
    SeatNumber          CHAR(3),
    SpecialMeal         ENUM('beef & rice', 'chicken & noodle', 'pizza'),
    SeatClass           ENUM('aisle', 'window', 'business', 'first', 'economy'),
    FOREIGN KEY (StopId1)      REFERENCES Airport(Id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (StopId2)      REFERENCES Airport(Id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (ReservationNumber) REFERENCES
   Reservation(ReservationNumber)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    UNIQUE KEY (FlightNumber, SeatNumber, StopId1, StopId2) ,
    PRIMARY KEY (Id)
);


CREATE TABLE Airport (
    Id      CHAR(3),
    Name    CHAR(60) NOT NULL,
    City    CHAR(60) ,
    Country CHAR(60),
    PRIMARY KEY (Id)
);

CREATE TABLE Flight (
    FlightNumber    INTEGER,
    Seats           INTEGER,
    FareRestriction CHAR(60), 
    Fare            INTEGER,
    AirlineId       CHAR(2),
    FOREIGN KEY (AirlineId) REFERENCES Airline(Id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
        CONSTRAINT FlightRange CHECK (FlightNumber > 0 AND
                                            FlightNumber < 10000),
    PRIMARY KEY (FlightNumber)
);


CREATE TABLE Manager (
EmployeeNumber  INTEGER,
    ManagerAcc INTEGER,
    ManagerPassword   CHAR(35),
    PRIMARY KEY(EmployeeNumber)
    );

CREATE TABLE Stop_at (
	ID            INTEGER,
    ArrivalTime   DATETIME,
    DepartureTime DATETIME,
    AirportId     CHAR(3),
    FlightNumber  INTEGER,
    
	PRIMARY KEY (ID),

    FOREIGN KEY (AirportId) REFERENCES Airport(Id)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,

    FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FlightRange CHECK (FlightNumber > 0 AND
                                        FlightNumber < 10000),
      UNIQUE KEY (ArrivalTime, DepartureTime, AirportId, FlightNumber)
);

CREATE TABLE Airline (
    Id CHAR(2),
    Name CHAR(50) NOT NULL,
    PRIMARY KEY (Id)
);

CREATE TABLE DaysOfWeek (
    FlightNumber INTEGER,
    DayOfWeek ENUM('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
    FOREIGN KEY (FlightNumber) REFERENCES Flight(FlightNumber)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (FlightNumber, DayOfWeek)
);
