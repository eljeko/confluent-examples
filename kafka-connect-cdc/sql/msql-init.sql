CREATE DATABASE crm;
GO
USE crm;
EXEC sys.sp_cdc_enable_db;

CREATE TABLE [Customers] (
	id integer NOT NULL UNIQUE,
	name varchar(50) NOT NULL,
	surname varchar(50) NOT NULL,
	address varchar(100) NOT NULL,
	zip_code varchar(10) NOT NULL,
	city varchar(20) NOT NULL,
	country varchar(20) NOT NULL,
	nickname varchar(20) NOT NULL,
  CONSTRAINT [PK_CUSTOMERS] PRIMARY KEY CLUSTERED
  (
  [id] ASC
  ) WITH (IGNORE_DUP_KEY = OFF)
)
GO

CREATE TABLE [Orders] (
	id integer NOT NULL IDENTITY(1,1) PRIMARY KEY,
	itemid integer NOT NULL,
	quantity integer NOT NULL,
	customerid integer NOT NULL
)
GO

ALTER TABLE [Orders] WITH CHECK ADD CONSTRAINT [Orders_fk0] FOREIGN KEY ([customerid]) REFERENCES [Customers]([id])
ON UPDATE CASCADE
GO
ALTER TABLE [Orders] CHECK CONSTRAINT [Orders_fk0]
GO

INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (1, 'Jack', 'Turner', 'South Boulevard 441', '37219', 'Indianapolis' ,'New York','j.turner')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (2, 'Maria', 'Reyes', 'Highland Drive 3', '66603', 'Los Angeles' ,'Texas','m_reyes')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (3, 'Larry', 'Thomas', 'College Avenue 554', '21401', 'Nashville' ,'Georgia','larry.thomas')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (4, 'Ashley', 'Edwards', 'Division Street 56', '59623', 'San Jose' ,'Missouri','aedwards')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (5, 'Katherine', 'Scott', 'Front Street 961', '57501', 'Milwaukee' ,'Michigan','katherine.s')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (6, 'Thomas', 'Hernandez', 'Meadowbrook Lane 14', '39205', 'Cleveland' ,'Ohio','thomas-h')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (7, 'Theresa', 'Foster', 'Cypress Street 7', '19901', 'San Francisco' ,'West Virginia','theresa-foster')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (8, 'Patricia', 'Davis', 'Main Road 0', '29217', 'Kansas City' ,'Oregon','patriciadavis')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (9, 'Debra', 'Wilson', 'Cherry Lane 4', '70802', 'Miami' ,'Nevada','debra_w')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (10, 'Anna', 'Thompson', 'Grandview Avenue 514', '55102', 'Miami' ,'Montana','a-thompson')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (11, 'Alice', 'Torres', 'Birch Lane 400', '55102', 'Sacramento' ,'Connecticut','alice_torres')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (12, 'Brian', 'Wood', 'Highland Avenue 5', '73102', 'Minneapolis' ,'New Hampshire','brian')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (13, 'Kyle', 'Garcia', 'East Main Street 1', '65101', 'St. Louis' ,'Alabama','kyle')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (14, 'Kevin', 'Garcia', 'Lakeside Drive 9', '78701', 'Seattle' ,'Connecticut','k.garcia')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (15, 'Christian', 'Gonzalez', 'Grandview Avenue 1', '37219', 'Denver' ,'New York','christian.g')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (16, 'Carolyn', 'Cox', 'Vineyard Avenue 72', '96813', 'Memphis' ,'New Jersey','c_cox')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (17, 'Jessica', 'Robinson', 'Franklin Street 826', '48933', 'Washington' ,'Idaho','jrobinson')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (18, 'George', 'Foster', 'Michigan Avenue 78', '23219', 'Sacramento' ,'Hawaii','george')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (19, 'Martha', 'Baker', 'Vineyard Avenue 3', '73102', 'Filadelfia' ,'Virginia','m.baker')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (20, 'Jean', 'Hall', 'Laurel Street 3', '62701', 'Las Vegas' ,'Oregon','jhall')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (21, 'George', 'Rogers', 'Broadway 9', '4330', 'San Antonio' ,'North Carolina','georger')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (22, 'Adam', 'Jackson', 'Juniper Drive 9', '17101', 'Pittsburgh' ,'Wisconsin','a-jackson')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (23, 'Samantha', 'Lee', 'Lexington Avenue 569', '12207', 'New York' ,'Arizona','s-lee')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (24, 'Katherine', 'Watson', 'Pineview Road 1', '89701', 'Filadelfia' ,'Indiana','kwatson')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (25, 'Sophia', 'Bennett', '6th Street 69', '62701', 'Detroit' ,'Massachusetts','s.bennett')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (26, 'Sharon', 'Garcia', 'Liberty Street 230', '83702', 'Tucson' ,'South Dakota','sharon')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (27, 'Steven', 'Lee', 'Willow Avenue 48', '5602', 'Seattle' ,'Ohio','stevenl')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (28, 'Benjamin', 'Torres', 'Ash Street 18', '37219', 'San Antonio' ,'Arizona','b_torres')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (29, 'Ronald', 'Cox', 'Hollywood Boulevard 827', '17101', 'Seattle' ,'Michigan','ronald.c')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (30, 'Nicholas', 'Jackson', 'Maple Street 23', '37219', 'Denver' ,'California','nicholas.j')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (31, 'Sandra', 'Walker', 'Hollywood Boulevard 0', '96813', 'Atlanta' ,'Iowa','s.walker')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (32, 'Matthew', 'King', 'High Street 629', '36104', 'Detroit' ,'Nebraska','matthew-k')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (33, 'Ronald', 'Walker', 'Broad Street 4', '83702', 'Filadelfia' ,'New York','r.walker')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (34, 'Jesse', 'Reyes', 'Oakwood Avenue 51', '62701', 'Columbus' ,'Ohio','jesse')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (35, 'Paul', 'Parker', 'Mill Street 286', '32301', 'Tampa' ,'Kentucky','paul')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (36, 'Louis', 'Stewart', 'Broadway 0', '84111', 'Fort Worth' ,'South Dakota','louis.s')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (37, 'Victoria', 'Hernandez', 'Mountain Road 92', '46225', 'Denver' ,'Colorado','v_hernandez')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (38, 'Lori', 'Hernandez', 'Magnolia Avenue 9', '96813', 'New Orleans' ,'California','lhernandez')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (39, 'Martha', 'Thompson', 'Madison Avenue 26', '68502', 'Columbus' ,'Virginia','m.thompson')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (40, 'Kelly', 'Cook', 'High Street 690', '32301', 'San Jose' ,'New York','kelly')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (41, 'Angela', 'Scott', 'Vineyard Avenue 21', '57501', 'Dallas' ,'Nebraska','a-scott')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (42, 'Larry', 'Sanders', 'College Avenue 269', '30303', 'Houston' ,'Washington','lsanders')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (43, 'Sophia', 'Mitchell', 'Mulberry Street 85', '50309', 'Charlotte' ,'Montana','smitchell')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (44, 'Russell', 'Rogers', 'Pine Street 402', '95814', 'Raleigh' ,'Kentucky','r_rogers')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (45, 'Judith', 'Alvarez', 'Western Avenue 36', '58501', 'Pittsburgh' ,'Washington','judith')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (46, 'Kathleen', 'Foster', 'Terrace Road 8', '12207', 'Washington' ,'Montana','k.foster')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (47, 'Brenda', 'Wood', 'River Road 34', '23219', 'Charlotte' ,'Montana','brenda')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (48, 'Evelyn', 'Gray', 'Park Street 3', '95814', 'Fort Worth' ,'Nebraska','e-gray')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (49, 'Juan', 'Peterson', 'Sycamore Street 0', '46225', 'Detroit' ,'Minnesota','j.peterson')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (50, 'Natalie', 'Kim', 'Pine Street 44', '83702', 'Houston' ,'Vermont','natalie')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (51, 'Pamela', 'Cox', 'South Boulevard 757', '50309', 'Washington' ,'Montana','p_cox')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (52, 'Kelly', 'Phillips', 'Broad Street 6', '23219', 'Louisville' ,'Arizona','k-phillips')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (53, 'Marie', 'Campbell', 'Cedar Lane 89', '02201', 'San Francisco' ,'West Virginia','mcampbell')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (54, 'Olivia', 'Patel', 'South Road 8', '29217', 'Tampa' ,'South Carolina','o-patel')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (55, 'Elijah', 'Sanchez', 'Congress Street 42', '84111', 'Sacramento' ,'Arizona','elijahsanchez')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (56, 'Judy', 'Ramos', 'South Avenue 11', '73102', 'Orlando' ,'Illinois','j.ramos')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (57, 'Heather', 'Lopez', 'Beach Boulevard 11', '8608', 'Chicago' ,'North Dakota','heather-l')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (58, 'Christian', 'Cox', 'Market Place 30', '80202', 'Tampa' ,'Maine','c.cox')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (59, 'Rachel', 'King', 'Beach Road 33', '84111', 'Boston' ,'North Carolina','r.king')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (60, 'Dylan', 'James', 'Maple Street 625', '72201', 'Cincinnati' ,'Oklahoma','dylan')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (61, 'Mary', 'Rivera', 'North Avenue 3', '6103', 'Houston' ,'Nebraska','mary')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (62, 'Anthony', 'Foster', 'Grand Avenue 889', '50309', 'Atlanta' ,'Alabama','a.foster')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (63, 'Melissa', 'Sanders', 'High Street 7', '36104', 'San Jose' ,'Kansas','melissa')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (64, 'Russell', 'Lewis', 'Church Street 27', '57501', 'Sacramento' ,'North Dakota','russell')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (65, 'Paul', 'Allen', 'Atlantic Avenue 0', '73102', 'Indianapolis' ,'New Hampshire','paul')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (66, 'Hannah', 'Campbell', 'Canal Street 7', '66603', 'Orlando' ,'Florida','h.campbell')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (67, 'Anna', 'Phillips', 'Mulberry Street 86', '8608', 'San Francisco' ,'California','anna.p')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (68, 'Betty', 'Miller', 'Brookside Avenue 5', '29217', 'Los Angeles' ,'West Virginia','b_miller')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (69, 'Jordan', 'Murphy', 'Union Street 48', '21401', 'Cleveland' ,'New Hampshire','jordan-m')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (70, 'Janice', 'Richardson', 'Oak Street 10', '19901', 'Detroit' ,'South Carolina','janice')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (71, 'Beverly', 'Morris', 'Elmwood Avenue 5', '83702', 'New Orleans' ,'South Dakota','beverly.morris')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (72, 'Barbara', 'Harris', 'Cherry Lane 3', '68502', 'Charlotte' ,'Pennsylvania','b.harris')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (73, 'Sara', 'Murphy', 'Rodeo Drive 66', '95814', 'Tucson' ,'Nevada','s_murphy')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (74, 'Mary', 'Ramos', 'Spring Street 6', '5602', 'Los Angeles' ,'North Carolina','mary.r')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (75, 'Nancy', 'Lewis', 'Market Street 002', '21401', 'Filadelfia' ,'Virginia','nlewis')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (76, 'Gloria', 'Lee', 'Laurel Street 92', '62701', 'San Jose' ,'Missouri','g.lee')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (77, 'Robert', 'Morris', '5th Avenue 2', '57501', 'Las Vegas' ,'Kentucky','rmorris')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (78, 'Eugene', 'Scott', 'Pine Street 86', '4330', 'Dallas' ,'Indiana','escott')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (79, 'Raymond', 'Adams', 'Canal Street 95', '30303', 'Kansas City' ,'Texas','raymond')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (80, 'Sara', 'Wood', 'Terrace Road 5', '70802', 'Fort Worth' ,'Montana','sara.w')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (81, 'Hannah', 'Sanchez', 'Juniper Drive 63', '46225', 'Detroit' ,'Oregon','h-sanchez')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (82, 'Jose', 'Smith', 'Walnut Street 068', '83702', 'Minneapolis' ,'Connecticut','jsmith')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (83, 'Lori', 'Mendosa', 'Park Place 9', '65101', 'New York' ,'Utah','l_mendosa')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (84, 'Ethan', 'Ross', 'Willow Avenue 394', '89701', 'Seattle' ,'Connecticut','e_ross')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (85, 'Diane', 'Bennett', 'Beach Boulevard 85', '37219', 'Austin' ,'California','d_bennett')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (86, 'Brian', 'Jackson', 'North Avenue 1', '99801', 'Louisville' ,'Minnesota','b-jackson')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (87, 'Cynthia', 'Roberts', 'Ocean Boulevard 15', '02201', 'Sacramento' ,'Nevada','c_roberts')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (88, 'Aaron', 'Johnson', 'Madison Avenue 190', '73102', 'Detroit' ,'Kansas','ajohnson')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (89, 'Eric', 'Stewart', 'Cypress Street 54', '83702', 'Tucson' ,'Connecticut','e_stewart')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (90, 'Elizabeth', 'Turner', 'Cedar Lane 7', '5602', 'Oklahoma City' ,'Montana','elizabeth')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (91, 'Ethan', 'Gomez', 'Beach Road 361', '3301', 'Jacksonville' ,'Arkansas','ethan_gomez')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (92, 'Alexis', 'Long', 'Pine Street 997', '40601', 'Minneapolis' ,'Arkansas','alexis.long')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (93, 'Nicholas', 'Green', 'Wall Street 4', '65101', 'Denver' ,'California','n.green')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (94, 'Frances', 'Moore', 'Hollywood Boulevard 63', '96813', 'Houston' ,'Texas','frances')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (95, 'Dorothy', 'Smith', 'Park Street 8', '50309', 'Charlotte' ,'Hawaii','dorothy')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (96, 'Katherine', 'Murphy', 'Michigan Avenue 848', '95814', 'Milwaukee' ,'Alabama','k-murphy')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (97, 'Barbara', 'Long', 'Willow Street 484', '39205', 'Tampa' ,'Florida','barbara')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (98, 'Anna', 'Murphy', 'Hillside Avenue 193', '84111', 'Las Vegas' ,'Mississippi','a-murphy')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (99, 'Lauren', 'Watson', 'Main Road 245', '4330', 'Denver' ,'Nebraska','lauren.watson')
INSERT INTO Customers (id, name, surname, address, zip_code, city, country, nickname) VALUES (100, 'Raymond', 'Nelson', 'Forest Avenue 26', '96813', 'Pittsburgh' ,'Iowa','r.nelson')

GO

EXEC sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Customers', @role_name = NULL, @supports_net_changes = 0;
EXEC sys.sp_cdc_enable_table @source_schema = 'dbo', @source_name = 'Orders', @role_name = NULL, @supports_net_changes = 0;
GO