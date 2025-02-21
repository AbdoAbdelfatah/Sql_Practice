-- 1.Create a scalar function that takes date and returns Month name of that date.

create function getMonth (@d date)
returns varchar(20)
	begin
		declare @month varchar(20);
		set @month =datename(month,@d);
		return @month;
	end 

select dbo.getMonth('2025-03-25');


--Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

create function getNums(@x int ,@y int )
returns @t table(
             num int
                )
	as 
	begin 
	     Declare @stValue int = @x;
		 while @stValue<=@y
			begin 
			    insert into @t values(@stValue);

				set @stValue=@stValue+1;
			end 
		 return 
end 

select *from getNums(3,15);


--3.Create inline function that takes Student No and returns Department Name with Student full name.

use iti 
 
create function getStuds(@Sid int)
returns table 
as
return (
   select s.Dept_Id,s.St_Fname+' '+s.St_Lname as fullName
   from Student s
   where s.St_Id=@Sid
)

select * from getStuds(11)


/*
4.Create a scalar function that takes Student ID and returns a message to user 
	a.	If first name and Last name are null then display 'First name & last name are null'
	b.	If First name is null then display 'first name is null'
	c.	If Last name is null then display 'last name is null'
	d.	Else display 'First name & last name are not null'
*/

create function checkNam(@Sid int)
returns varchar(50)
begin
    declare @ans varchar(50);
	declare @f varchar(20),@l varchar(20);
	select @f=s.St_Fname,@l=s.St_Lname from student s where St_Id=@Sid;
		if @f is null and @l is null 
		set @ans ='First name & last name are null'
		else if @f is null 
		set @ans ='first name is null'
		else if @l is null 
		set @ans ='last name are null'
		else set @ans ='First name & last name are not null'
return @ans;
end 

select dbo.checkNam(14);


/* 
5.Write a query that returns the Student No and Student first name without the last char
*/

SELECT s.St_Id, LEFT(s.St_Fname, LEN(s.St_Fname) - 1) AS FirstNameWithoutLastChar
FROM Student s
WHERE LEN(s.St_Fname) > 1;
