SELECT * 
From PortfolieProject..CovidDeath
WHERE continent is not null
ORDER BY 3,4

--SELECT * 
--From PortfolieProject..CovidVaccination
--ORDER BY 3,4

--SELECT Data that we are going to be using

SELECT  location, date, total_cases, new_cases, total_deaths, Population
From PortfolieProject..CovidDeath
ORDER BY 1,2

----Looking at Total Cases vs Total Death


SELECT  location, date, total_cases, total_deaths,  (total_deaths/total_cases) * 100 as CaseDealthPercentage
From PortfolieProject..CovidDeath
WHERE location like '%united%'
ORDER BY 1,2 

----LOOKING AT TOTAL CASES VS POPULATION

SELECT  location, date, total_cases, Population, (total_cases/Population)*100 as CaseDeathPercentage
From PortfolieProject..CovidDeath
WHERE location like '%states%'
ORDER BY 1,2

----LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT  location, Population, MAX(total_cases) as HighestInfectionCount, MAX(total_cases/Population)*100 as PercentPopulationInfected
From PortfolieProject..CovidDeath
--WHERE location like '%states%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC


----Let's break it down by continent


SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolieProject..CovidDeath
--WHERE location like '%states%'
WHERE Continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC


SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolieProject..CovidDeath
--WHERE location like '%states%'
WHERE Continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


-----SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATI-ON


SELECT  location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolieProject..CovidDeath
--WHERE location like '%states%'
WHERE Continent is not null
GROUP BY Location, Population
ORDER BY TotalDeathCount DESC


----SHOWING CONTINENTS WITH HIGHEST DEATH COUNT PER POPULATION




SELECT  continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolieProject..CovidDeath
--WHERE location like '%states%'
WHERE Continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC


----GLOBAL NUMBERS
CREATE VIEW TotalDealthPopulation  as
SELECT  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(new_cases) * 100 as CaseDealthPercentage
From PortfolieProject..CovidDeath
--WHERE location like '%state%'
where continent is not null
GROUP BY date
--ORDER BY 1,2 

----LOOKING AT TOTAL POPULATION VS VACCINATION
With PopvsVac (Continent,	Location, Date, Populatin, new_vaccinations_smoothed, RollingPeopleVaccinated)
as
(
SELeCT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations_smoothed ,  SUM(CONVERT(bigint, Vac.new_vaccinations_smoothed )) OVER(PARTITION BY Dea.location ORDER BY Dea.location,
Dea.date) AS RollingPeopleVaccinated
 --(RollingPeopleVaccinated/Population)*100
FROM PortfolieProject..CovidDeath Dea
JOIN PortfolieProject..CovidVaccination Vac
ON Dea.location = Vac.location
AND Dea.date= Vac.date
WHERE Dea.continent is not null 
--ORDER BY 2,3
)
SELECT *
FROM PopvsVac

----USE CTE

--TEMP TABLE

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations_smoothed numeric,
RollingPeopleVaccinated numeric
)
INSERT #PercentPopulationVaccinated
SELeCT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations_smoothed ,  SUM(CONVERT(bigint, Vac.new_vaccinations_smoothed )) OVER(PARTITION BY Dea.location ORDER BY Dea.location,
Dea.date) AS RollingPeopleVaccinated
 --(RollingPeopleVaccinated/Population)*100
FROM PortfolieProject..CovidDeath Dea
JOIN PortfolieProject..CovidVaccination Vac
ON Dea.location = Vac.location
AND Dea.date= Vac.date
WHERE Dea.continent is not null 
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


----HOW TO CREATE A VIEW TO STORE  DATA FOR LATER VISULIZATION

CREATE VIEW PercentPopulationVaccinated as
SELeCT Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations_smoothed ,  SUM(CONVERT(int, Vac.new_vaccinations_smoothed )) OVER(PARTITION BY Dea.location ORDER BY Dea.location,
Dea.date) AS RollingPeopleVaccinated
 --(RollingPeopleVaccinated/Population)*100
FROM PortfolieProject..CovidDeath Dea
JOIN PortfolieProject..CovidVaccination Vac
ON Dea.location = Vac.location
AND Dea.date= Vac.date
WHERE Dea.continent is not null 
--ORDER BY 2,3

--SELECT *
--FROM PercentPopulationVaccinated