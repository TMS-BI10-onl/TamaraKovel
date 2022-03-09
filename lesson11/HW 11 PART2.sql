/*Школа
PupilsDim (IdPupil, FullName, BirthDate, Gender, IdClass)
ClassesDim (IdClass, Year, Letter) 
TeachersDim (IdTeacher, FullName, BirthDate, Gender, Phone, Email, Qualification)
SubjectsDim (IdSubject, Name) 
ClassRoomsDim (IdClassRoom, Name, Floor, Status)
TimeTableFct (IdTimeTable, IdClass, IdTeacher, IdSubject, IdClassRoom, DayOfWeek, LessonOrder (какой по очереди в этот день))
MarksFct (IdMark, IdPupil, IdTeacher, IdSubject, DateCreated, IsAbsent, MarkValue)*/

/*Вывести средний балл учеников для каждой параллели по каждому предмету. 
Результаты вывести в виде транспонированной таблицы (оси - предмет и параллель).*/

SELECT class, Name [x], [y]..... as [x],[y].....
FROM 
(SELECT s.Name, CONCAT(c.Year, c.Letter) as class, MarkValue
FROM  MarksFct m 
JOIN SubjectsDim s ON m.IdSubject=s.IdSubject
JOIN PupilsDim p ON m.IdPupil=p.IdPupil
JOIN ClassesDim c ON p.IdClass=c.IdClass) 
AS SourceTable  
PIVOT
( 
	AVG(MarkValue)
	FOR Name IN ([x], [y]....)
) AS PivotTable

/*Проверить, повышает ли преподаватель оценки в свой день рождения (настроение-то лучше :). 
Вывести преподавателя, средний балл в день рождения, средний балл за остальные дни.*/

SELECT a.FullName, a.BirthDate, AVG(a.MarkValue)
FROM (SELECT t.FullName as FullName, t.BirthDate as BirthDate, m.MarkValue as MarkValue
FROM TeachersDim t
JOIN MarksFct m ON t.IdTeacher=m.IdTeacher) a
GROUP BY a.FullName





