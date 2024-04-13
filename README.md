# Olympic History SQL Problems
* I solved 20 complex SQL problems relating to Olympic data provided by a well known youtuber TechTFQ in [this blog.](https://techtfq.com/blog/practice-writing-sql-queries-using-real-dataset)  
* These problems were designed to showcase complex SQL skills. 
* **You can view the queries I used to solved these problems [HERE](https://github.com/dustin-tucker01/OlympicHistorySQLProblems/blob/main/Solved%20Olympic%20Problems.sql)**

### Tables 
Here are the first few rows of each table that I used to solve the problems below. 

<details>
    <summary> Athlete Events (over 270,000 rows) </summary>
    <p>
      
| ID | Name                        | Sex | Age | Height | Weight | Team             | NOC | Games          | Year | Season | City       | Sport           | Event                                 | Medal |
|----|-----------------------------|-----|-----|--------|--------|------------------|-----|----------------|------|--------|------------|------------------|---------------------------------------|-------|
| 1  | A Dijiang                   | M   | 24  | 180    | 80     | China            | CHN | 1992 Summer    | 1992 | Summer | Barcelona  | Basketball       | Basketball Men's Basketball            | NA    |
| 2  | A Lamusi                    | M   | 23  | 170    | 60     | China            | CHN | 2012 Summer    | 2012 | Summer | London     | Judo             | Judo Men's Extra-Lightweight           | NA    |
| 3  | Gunnar Nielsen Aaby         | M   | 24  | NA     | NA     | Denmark          | DEN | 1920 Summer    | 1920 | Summer | Antwerpen  | Football         | Football Men's Football                | NA    |
| 4  | Edgar Lindenau Aabye        | M   | 34  | NA     | NA     | Denmark/Sweden   | DEN | 1900 Summer    | 1900 | Summer | Paris      | Tug-Of-War       | Tug-Of-War Men's Tug-Of-War            | Gold  |
| 5  | Christine Jacoba Aaftink    | F   | 21  | 185    | 82     | Netherlands       | NED | 1988 Winter    | 1988 | Winter | Calgary    | Speed Skating    | Speed Skating Women's 500 metres       | NA    |
| 5  | Christine Jacoba Aaftink    | F   | 21  | 185    | 82     | Netherlands       | NED | 1988 Winter    | 1988 | Winter | Calgary    | Speed Skating    | Speed Skating Women's 1,000 metres     | NA    |

</p>
</details>

<details>
    <summary>NOC Regions (230 rows) </summary>
    <p>
      
| NOC | Region       | Notes               |
|-----|--------------|---------------------|
| AFG | Afghanistan  |                     |
| AHO | Curacao      | Netherlands Antilles|
| ALB | Albania      |                     |
| ALG | Algeria      |                     |
| AND | Andorra      |                     |
</p>
</details>

## Problems 
1. *How many olympics games have been held?*
2. *List down all Olympics games held so far.*
3. *Mention the total no of nations who participated in each olympics game?*
4. *Which year saw the highest and lowest no of countries participating in olympics?*
5. *Which nation has participated in all of the olympic games?*
6. *Identify the sport which was played in all summer olympics.*
7. *Which Sports were just played only once in the olympics?*
8. *Fetch the total no of sports played in each olympic games.*
9. *Fetch details of the oldest athletes to win a gold medal.*
10. *Find the Ratio of male and female athletes participated in all olympic games.*
11. *Fetch the top 5 athletes who have won the most gold medals.*
12. *Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).*
13. *Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.*
14. *List down total gold, silver and broze medals won by each country.*
15. *List down total gold, silver and broze medals won by each country corresponding to each olympic games.*
16. *Identify which country won the most gold, most silver and most bronze medals in each olympic games.*
17. *Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.*
18. *Which countries have never won gold medal but have won silver/bronze medals?*
19. *In which Sport/event, India has won highest medals.*
20. *Break down all olympic games where india won medal for Hockey and how many medals in each olympic games.*

