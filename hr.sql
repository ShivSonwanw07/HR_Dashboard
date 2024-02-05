
#creating a datbase
create database human_resources;

#Using database human_resources
use human_resources;

select * from hr;

describe hr;
#as we can see the data type of each column is "text" so we need to change it


				                   #Data Cleaning#
                                   
#changing the data_type of column-(id)
alter table hr
modify column id varchar(20);

#updating the column-(birthdate) in standard date format
update hr 
set birthdate=case
when birthdate like '%/%' then date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

#changing the data type of column-(birthdate)
alter table hr
modify column birthdate date;

#updating the column-(hire_date) in standard date format
update hr 
set hire_date=case
when hire_date like '%/%' then date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date like '%-%' then date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

#changing the data type of column-(hire_date)
alter table hr
modify column hire_date date;




#updating the column-(termdate) in standard date format
update hr
set termdate=case
when termdate like '%-%' then date_format(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'),'%Y-%m-%d')
else null
end;


#changing the data type of column-(termdate)
alter table hr
modify column termdate date;


#adding column-(age) 
alter table hr 
add column age int;

# calculating and inserting age into column-(age)
update hr
set age = timestampdiff(YEAR,birthdate,curdate());

select min(age) as youngest,
max(age) as oldest
from hr;

select age from hr
where age<18;
# from above query we can see that the ages are in negative 
# so we need to remove those rows

#removing ages that are negative
delete from hr
where age<18;

select count(*) from hr
where termdate>curdate();

select count(*) from hr
where termdate is null;

select location from hr;


                           #Questions#
#1. What is the gender breakdown of employees in the company?

select 
     gender,
     count(gender) as count
from hr
where termdate is null 
group by gender;

#2. What is the race/ethnicity breakdown of employees in the company?

select 
      race,
      count(race)
from hr 
where termdate is null
group by race;

#3. What is the age distribution of employees in the company?

select 
     min(age) as youngest,
     max(age) as oldest
from hr
where termdate is null;

select case
         when age between 18 and 24 then '18-24'  
         when age between 25 and 30 then '25-30'
         when age between 31 and 35 then '31-35'
         when age between 36 and 40 then '36-40'
         when age between 41 and 45 then '41-45'
         when age between 46 and 50 then '46-50'
         when age between 51 and 55 then '51-55'
         when age between 56 and 60 then '56-60'
         else '65+'
         end as age_group, 
         count(age) as count
from hr
where termdate is null
group by age_group
order by age_group;
         
#4. How many employees work at headquarters versus remote locations?
select 
     location,
     count(location)
from hr 
where termdate is null
group by location;



#5. What is the average length of employment for employees who have been terminated?
select 
     round(avg(timestampdiff(year,hire_date,termdate)),0) as avg_length_of_employment
from hr
where termdate is not null and termdate<=curdate();
         
#6. How does the gender distribution vary across departments?
select 
     department,
     gender,
     count(*) as count
from hr 
group by department,gender
order by department;

#7. What is the distribution of job titles across the company?
select 
     jobtitle,
     count(*) as count
from hr 
group by jobtitle
order by jobtitle;

#8. Which department has the highest turnover rate?

#turnover rate= no.of employee who left or got fired / total no. of employee

select 
     department,
	 total_count,
     terminated_count,
     terminated_count/total_count as turnover_rate
from(
  select 
       department,
       count(*) as total_count,
       count(termdate) as terminated_count
  from hr
  group by department) as sub_query
  order by turnover_rate desc;
  
#9. What is the distribution of employees across locations by state?

select 
     location_state,
     count(*) as count 
from hr
where termdate is null
group by location_state;
	
#10. How has the company's employee count changed over time based on hire and term dates?

select 
     year(hire_date) as year,
     count(*) as hires,
     count(termdate) as terminations,
     count(*)-count(termdate) as net_change,
     round(((count(*)-count(termdate))/count(*))*100,2) as net_change_percentage
from hr 
group by year
order by year ;

#11. What is the tenure distribution for each department?

#Tenure is the length of time an employee has worked for the company

select 
	department,
    avg(timestampdiff(year,hire_date,termdate)) as avg_tenure
from hr
where termdate<= curdate() and termdate is not null
group by department
order by department;
