/*
Create the following database using wizard Consists of 2 File Groups 
{ SeconderyFG (has two data files) and ThirdFG (has two data files) } 
*/
USE SD;
SELECT name, type_desc, data_space_id, physical_name 
FROM sys.master_files
WHERE database_id = DB_ID('SD');



----------------------------

use SD;
/*
1.	Create the Department table 
-Create a new user data type named loc with the following Criteria:
•	nchar(2)
•	default:NY 
•	create a rule for this Datatype :values in (NY,DS,KW)) and associate it to the location column  
*/
create rule r1 as @x in ('NY','DS','KW');
create default d1 as 'NY';
sp_addtype 'loc' , 'nchar(2)';

sp_bindrule r1,loc;
sp_bindefault d1,loc;

create table Department(
DeptNo int primary key,
DeptName varchar(20),
Location loc
)


/*
Create the Employee table 
1-Create it by code
2-PK constraint on EmpNo
3-FK constraint on DeptNo
4-Unique constraint on Salary
5-EmpFname, EmpLname don’t accept null values
6-Create a rule on Salary column to ensure that it is less than 6000 
*/
create table Employee(
EmpNo  int primary key,
EmpFname varchar(20) not null,
EmpLname varchar(20) not null,
DeptNo int FOREIGN KEY REFERENCES Department(DeptNo),
Salary int unique,
);

create rule r2 as @x <6000;
sp_bindrule r2,'Employee.Salary';


/*
Create the Project table 
1-ProjectName can't contain null values
2-Budget allow null
*/

create table Project(
ProjectNo int primary key,
ProjectName varchar(50) not null,
Budget int
);

/*
Create the Works_on table 
1- EmpNo INTEGER NOT NULL
2-ProjectNo doesn't accept null values
3-Job can accept null
4-Enter_Date can’t accept null
and has the current system date as a default value[visually]
5-The primary key will be EmpNo,ProjectNo) 
6-there is a relation between works_on and employee, Project  tables
*/

create table Works_on(
EmpNo INTEGER NOT NULL,
ProjectNo INTEGER NOT NULL,
Job VARCHAR(50) NULL, 
Enter_Date DATE NOT NULL DEFAULT GETDATE(),
constraint c1 primary key(EmpNo,ProjectNo),
constraint c2 foreign key (ProjectNo) REFERENCES Project(ProjectNo) 
on delete cascade on update cascade,
constraint c3 foreign key (EmpNo) REFERENCES Employee(EmpNo) 
on delete cascade on update cascade,
)

/*
1	Create the following schema and transfer the following tables to it 
a.	Company Schema 
	i.	Department table (Programmatically)
	ii.	Project table (using wizard)
b.	Human Resource Schema
	i.	  Employee table (Programmatically)
*/

create schema Company;
alter schema Company transfer Department; 
alter schema Company transfer Project; 

create schema HumanResource;	
alter schema HumanResource transfer Employee;


-- 2.Create Synonym for table Employee as Emp and
-- then run the following queries and describe the results

create synonym Emp
for HumanResource.Employee;

Select * from Emp;


/*
Increase the budget of the project where the manager number is 10102 by 10%.
*/

update Company.Project 
set Budget += (Budget*0.1)
from Company.Project p inner join Works_on w
on p.ProjectNo=w.ProjectNo and w.EmpNo=10102;


/*
Change the name of the department for which the employee named Ann.
The new department name is Sales.
*/

update d
set d.DeptName='Sales'
from Emp e inner join Company.Department d
on d.DeptNo=e.DeptNo and e.EmpFname ='Ann';
