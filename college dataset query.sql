-- Find the number of students who are studying in BSc CS and also their gender is female.

select count(*) as num_of_fem_students from college_dataset
where course = "B.Sc(CS)" and gender = "F";

-- Show the list of students who are studying in CBZ and also their course fees is 16000.

select * from college_dataset 
where course = "CBZ" and Course_Fees = "16000";

-- show the list of students their first name like Ajay Anuj Dhruv Gaurav Jatin and Nitin of bsc CS group

select * from college_dataset
where First_Name in ('ajay','gaurav','Dhruv','nitin','jatin') and course = "B.Sc(CS)";

-- Show the list of students their last name like Chaudhary, Sharma, Mishra and Pal.

select * from college_dataset
where last_name in ('chaudhary','sharma','mishra','pal');

-- The college people have thought of conducting elections in the college. So, the criteria for selecting the representative has been kept in such a way that the one whose attendance is above 80 percents and marks more than 80 percents in the last exam.

select First_Name, last_name, gender, course from
(select *, round((Marks_in_last_examination/1200)*100,0) as marks_obtained_in_percentage, round((attandence/`total_no._of_class`)*100,0) as attandence_percentage
from college_dataset) as a where attandence_percentage > 80 and marks_obtained_in_percentage > 80;

-- show the list of students that have more than 80% of their attendance
 
select *, round((attandence/'total_no._of_class')*100,0) from college_dataset
where Attandence > 80;

-- find the student that have earned 5th rank for their course group according to their marks.
select * from 
(select *, round((Marks_in_last_examination/1200)*100,0) as percentage, dense_rank() over(partition by course order by marks_in_last_examination desc) as percent_rank_ from college_dataset) as a
where percent_rank_ =5;

-- It is a matter of time before some children were playing cricket before the exam in the college, one of them hit glass of the principal's car, 
-- principal fined all those children equally, so now show that if the price of that glass is 6 thousand rupees, then how much money will be increased among all, 
-- after the relaxation of their fees, the roll numbers of those children are like this 13,19,57,43,95,63, 23.
select *, round((6000)/7+course_fees) as car_glass_broken_fees from college_dataset
where Roll_No in (13,19,57,43,95,63,23);

-- Show the list of top 5 rank holders for each course according to their marks.
select * from
(select *, round(marks_in_last_examination/1200*100,0) as percentage_obtained, dense_rank() over(partition by course order by percentage_obtained desc)
as percentage_rank from college_dataset) as a
where percentage_rank in (1,2,3,4,5);

-- Show the list of students that earn more than 80% in their practical but earn less than 65% in their theory examination.

select * from
(select *, round(cd.Marks_in_Last_Examination/1200*100,0) as percent, round(pm.marks_of_practical_out_of_120/120*100,0) as percent_mark from college_dataset as cd
join practical_marks as pm on cd.roll_no = pm.roll_no_) as a
where percent > 80 and percent_mark < 65;

-- So all the details of the students after relaxation in their fees.

select *, round(course_fees-relaxation) as total_fees_after_relaxation from college_dataset join relaxation on college_dataset.Roll_No = relaxation.roll_no__;

-- Show the list of students that were failed in the exam according to their total marks. (let's say less than 60%)

select * from
(select *, round(Marks_in_Last_Examination/1200*100,0) as marks_percent, 
case 
when round(Marks_in_Last_Examination/1200*100,0) < 40 then 'failed'
when round(Marks_in_Last_Examination/1200*100,0) = 40 then 'passed'
when round(Marks_in_Last_Examination/1200*100,0) > 60 then 'avg_marks'
else 'excellent'
end as result
from college_dataset) as a
where result = 'failed';

-- The college committee decided to give 5000 relaxation in the fees of students who have attendance more than 95%. Now show the list of students with all other details after relaxation their fees refer(So all the details of the students after relaxation in their fees.) and additional relaxation of their fees according to their attendance.

select *,(course_fees-total_fees_after_relaxation_of_above_95_percetange) as total_fees_student_have_to_give from
(select *, round((attandence/`total_no._of_class`)*100,0) as attandence_percentage from 
(select *, round(course_fees-`relaxation`) as total_fees_after_relaxation, round(relaxation+5000) as total_fees_after_relaxation_of_above_95_percetange 
from college_dataset join relaxation on college_dataset.Roll_No = relaxation.roll_no__)as a)as b
where attandence_percentage >95;

-- Show the list of students who have scored 100 in their practical exam according to their course group.

select *, dense_rank() over(partition by courses order by roll_no_)from practical_marks
where Marks_of_Practical_Out_Of_120 = 100;
