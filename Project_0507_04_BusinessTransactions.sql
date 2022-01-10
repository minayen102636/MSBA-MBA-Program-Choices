USE BUDT703_Project_0507_04;
--1.What are the different institutions that rank Robert H. Smith MSBA program throughout the years ? (Mission statement 2)
SELECT DISTINCT i.insName, u.uniName,a.uniRank,p.prgName,a.uniRankYear FROM [TurboRank.University] u,[TurboRank.Associate] a, [TurboRank.RankInstitution] I,[TurboRank.Program] p
WHERE a.uId=u.uId AND i.rId=a.rId AND u.uId=p.uId AND u.uniName LIKE '%Maryland%'
AND p.prgName LIKE '%Analytics%'
AND i.rId = a.rId
GROUP BY i.insName,U.uniName,a.uniRank,p.prgName,a.uniRankYear ORDER BY I.insName
--2.Which MSBA programs has an alumni outcome with 100% of alumni being responsive and involved? (Mission statement 1)
SELECT u.uniName,p.prgName,c.rptAlumniOutcomes
FROM [TurboRank.University] u,[TurboRank.Program] p,[TurboRank.Connect] c
WHERE p.pId=c.pId
AND c.rptAlumniOutcomes >= 100.0
GROUP BY u.uniName,p.prgName,c.rptAlumniOutcomes ORDER BY u.uniName
--3.What are the different rankings for MSBA programs with the TOP 4 employment rate?(mission statement 3)
SELECT b.[TOP 4 Employmentrate],b.prgName,b.uniName,f.uId,f.uniRank FROM(
SELECT TOP(4) i.prgEmploymentRate AS 'TOP 4 Employmentrate',p.prgName,u.uniName,u.uId
FROM [TurboRank.ProgramInformation] i, [TurboRank.Program] p, [TurboRank.University] u
WHERE i.pId=p.pId AND p.uId=u.uId AND p.prgName LIKE '%Analytics %'
ORDER BY i.prgEmploymentRate DESC) b,(
SELECT a.uniRank,a.uniRankYear,a.uId
FROM [TurboRank.Associate] a, [TurboRank.University] u WHERE a.uId=u.uId) f
WHERE f.uid=b.uid
--4.Which university has a higher score of diversity? (referring to Mission statement 1)
SELECT DISTINCT u.uId, u.uniName, c.rptDiversity AS 'Diversity Score' FROM [TurboRank.Connect] c, [TurboRank.ProgramInformation] i, [TurboRank.Program] p, [TurboRank.University] u

WHERE p.uId = u.uId AND p.pId = i.pId AND i.pId = c.pId AND c.rptDiversity =(
SELECT MAX(c.rptDiversity) FROM [TurboRank.Connect] c)
--5.What are the MSBA programs with mean Gmat score less than or equal to 700 and mean undergraduate GPA less than or equal to 3.5? (referring to Mission statement 1)
SELECT DISTINCT p.pId, p.prgName AS 'Program Name', i.prgMeanGMAT, i.prgMeanUndergradGPA
FROM [TurboRank.ProgramInformation] i, [TurboRank.Program] p
WHERE i.prgMeanGMAT <= 700 AND i.prgMeanUndergradGPA <= 3.5 AND (p.prgName LIKE '%Analytics%')AND p.pId = i.pId
--6.What are the details of the top five MBA programs in each ranking source in 2021? (referring to Mission statement 3)
SELECT TOP 5 c.prgRank AS 'Program Ranking', r.insName AS 'Ranking Source', i.*
FROM [TurboRank.ProgramInformation] i, [TurboRank.Program] p, [TurboRank.Connect] c, [TurboRank.RankInstitution] r
WHERE c.pId = i.pId AND i.pId= p.pId AND c.prgRankYear = 2021 AND i.prgRankYear = 2021 AND (p.prgName LIKE '%Administration%') ORDER BY c.prgRank
--7.What is the Diversity/Emplpyability/AlumniOutcome scores of top 4 ranking MBA programs from QS in 2021?
SELECT DISTINCT TOP(4) u.uniName, p.prgName, c.prgRank, c.rptDiversity, c.rptEmployability, c.rptAlumniOutcomes
FROM [TurboRank.University] u, [TurboRank.Program] p, [TurboRank.Connect] c, [TurboRank.RankInstitution] r
WHERE u.uId = p.uId AND p.pId = c.pId AND c.prgRankYear = 2021 AND r.rId = 'r01' AND r.rId=c.rId
AND (p.prgName LIKE '%Administration%') ORDER BY c.prgRank
--8.For a researcher who would like to analyze the relationship between the scores of selective students of the MSBA program and the corresponding ranking in QS. The first step is to get the data.
-- What are the scores of selective students of the MSBA program and the corresponding program ranking in QS? (Mission Statement 3)
SELECT i.prgMeanGMAT, i.prgmeanGRE, i.prgMeanTOEFL, i.prgMeanUndergradGPA, c.prgRank
FROM [TurboRank.ProgramInformation] i, [TurboRank.Connect] c WHERE i.pId = c.pId AND i.prgRankYear = c.prgRankYear AND c.rId IN (

SELECT r.rId
FROM [TurboRank.RankInstitution] r
WHERE r.insName = 'QS World University Rankings') AND i.pId IN ( SELECT p.pId
FROM [TurboRank.Program] p
WHERE p.prgName LIKE '%Analytics%')
--9.What is the number of core courses that each program provides and how many credits of these courses in total? (Mission Statement 3)
SELECT a.pId, a.[Number of Core Courses], b.[Total Credits of Core Courses] FROM (
SELECT h.pId, COUNT(h.cId) AS 'Number of Core Courses'
FROM [TurboRank.Have] h
GROUP BY h.pId) a, (
SELECT h.pId, SUM(c.crsCredit) AS 'Total Credits of Core Courses' FROM [TurboRank.Course] c, [TurboRank.Have] h
WHERE c.cId = h.cId
GROUP BY h.pId) b WHERE a.pId = b.pId
--10.Which MSBA programs provide the data mining course?
SELECT u.uniName, p.prgName
FROM [TurboRank.Have] h, [TurboRank.Program] p, [TurboRank.University] u WHERE h.pId = p.pId AND p.uId = u.uId AND p.prgName LIKE '%Analytics%' AND h.cId IN (
SELECT c.cId
FROM [TurboRank.Course] c
WHERE c.crsName LIKE '%Data Mining%')
--11.What are the top ten programs with the highest international student rate? (Mission statement 1)
SELECT TOP(10) i.prgIntStudentRate, u.uniName, p.prgName
FROM [TurboRank.ProgramInformation] i, [TurboRank.Program] p, [TurboRank.University] u
WHERE i.prgIntStudentRate IS NOT NULL AND p.pId = i.pId
AND p.uId = u.uId ORDER BY i.prgIntStudentRate
--12.What are the program and its university 2021 QS ranking of all programs that are more than 18 months? (mission statement 2)

SELECT DISTINCT u.uniName, a.uniRank, p.prgName, c.prgRank, p.prgDuration
FROM [TurboRank.University] u, [TurboRank.Associate] a, [TurboRank.Connect] c,
[TurboRank.Program] p, [TurboRank.ProgramInformation] i, [TurboRank.RankInstitution] r
WHERE u.uId =p.uId
AND u.uId = a.uId
AND a.uniRankYear ='2021' AND p.pId = i.pId
AND i.pId = c.pId
AND c.rId = r.rId
AND i.prgRankYear='2021' AND r.insName LIKE '%QS%' AND a.rId = r.rId
AND p.prgDuration > 18
ORDER BY c.prgRank
--13.A students undergraduate GPA is 3.5, he wants to know which program s average undergraduate GPA is not more than 3.5 in 2021, and its TOFEL, GRE requirement. (mission statement 1)
SELECT DISTINCT u.uniName, p.prgName,i.prgMeanUndergradGPA,i.prgMeanTOEFL,i.prgMeanGRE
FROM [TurboRank.University] u, [TurboRank.Program] p, [TurboRank.ProgramInformation] i
WHERE u.uId = p.uId
AND p.pId = i.pId
AND i.prgMeanUndergradGPA IS NOT NULL AND i.prgRankYear ='2021'
AND i.prgMeanUndergradGPA <= 3.5
ORDER BY i.prgMeanUndergradGPA DESC
--14.What is the program information of the highest ROI MBA program? (mission statement 1)
SELECT*
FROM [TurboRank.ProgramInformation] I
WHERE I.pId IN ( SELECT C.pId
FROM [TurboRank.Connect] C WHERE C.rptROI IN (
SELECT MAX(O.rptROI)
FROM [TurboRank.Connect] O))
--15.Is higher program ranking have higher employment rate for MBA?

(mission statement 2)
SELECT C.prgRank, I.prgEmploymentRate
FROM [TurboRank.Connect] C, [TurboRank.ProgramInformation] I WHERE C.pId IN (
SELECT P.pId
FROM [TurboRank.Program] P
WHERE P.prgName LIKE '%Administration%')
ORDER BY C.prgRank
--16.What is the mean starting salary and tuition for MSBA in ascending order? (mission statement 1)
SELECT I.prgMeanStartSalary, I.prgTuition
FROM [TurboRank.ProgramInformation] I, [TurboRank.Program] P WHERE I.pId = P.pId AND P.prgName LIKE '%Analytics%'
ORDER BY I.prgMeanStartSalary, I.prgTuition
--17.What is the average undergraduate GPA of the top 10 programs with highest GMAT score in 2021?
SELECT TOP 10 u.uniName, p.prgName, i.prgMeanGMAT, i.prgMeanUndergradGPA
FROM [TurboRank.ProgramInformation] i,[TurboRank.Program] p, [TurboRank.University] u
WHERE i.prgRankYear = '2021'
AND p.uId = u.uId
AND p.pId = i.pId
ORDER BY i.prgMeanGMAT DESC
--18.What are the average tuition,starting salary and ROI score of QS World University Ranking for MBA in descending order?
SELECT DISTINCT TOP (10) u.uniName, p.prgName, AVG(i.prgTuition) AS 'Average tuition',
AVG(i.prgMeanStartSalary) AS 'Average starting salary', AVG(c.rptROI) AS 'Average ROI'
FROM [TurboRank.University] u, [TurboRank.Program] p, [TurboRank.ProgramInformation] i,[TurboRank.Connect] c WHERE u.uId = p.uId
AND p.pId = i.pId
AND p.pId = c.pId
AND P.prgName = 'Master of Business Administration'
GROUP BY p.uId,p.pId, u.uniName, p.prgName ORDER BY AVG(i.prgTuition) DESC
--19.Which universities provide a MSBA program with duration of no more than one-year and tuition of no more than $55000
SELECT u.uniName, d.prgDuration AS 'Program Duration', d.prgTuition AS 'Program Tuition'

FROM (
SELECT p.uId, p.prgDuration, i.prgTuition
FROM [TurboRank.ProgramInformation] i, [TurboRank.Program] P WHERE i.pId = p.pId AND i.prgTuition <= 55000 AND p.prgName LIKE
'%Analytics%' AND p.prgDuration <= 12 AND i.prgRankYear = '2021') d, [TurboRank.University] u
WHERE d.uId = u.uId ORDER BY d.prgDuration
