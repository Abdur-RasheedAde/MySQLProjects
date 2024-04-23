/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Dataset preview
SELECT * 
FROM AbdulRasheedDB.dbo.CovidDeaths
ORDER BY 1,2


SELECT *
FROM AbdulRasheedDB.dbo.CovidVaccinations
ORDER BY 3,4

--Select percific data and using AbdulRasheedDB..CovidDeaths$ inplace of AbdulRasheedDB.db.CovidDeaths$
SELECT Location, Date, total_cases, new_cases, total_deaths, population
FROM AbdulRasheedDB..CovidDeaths
ORDER BY 1,2


-- Total case vs population 
-- Shows what percentage of population got Covid in Nigeria
SELECT Location, Date, total_cases,  population, (total_cases/population)*100 as PercentPopulationInfected 
FROM CovidDeaths
WHERE Location like '%Nigeria%'
order by 1,2

-- Checking Countries with Highest Infection Rate compared to Population 
SELECT Location, MAX(total_cases) as HighestCovidCase,  population, 
MAX((total_cases/population))*100 as PercentPopulationInfected 
FROM CovidDeaths
GROUP BY Location, population
order by PercentPopulationInfected DESC

-- Checking Countries with Highest death per Population 
SELECT Location, MAX(total_deaths) as TotalDeathCount 
FROM CovidDeaths
GROUP BY Location, population
order by TotalDeathCount DESC

-- Casting Total Death AS INTEGER for DataValidation
SELECT Location, MAX(CAST(total_deaths AS INT)) as TotalDeathCount 
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location, population
order by TotalDeathCount DESC

-- Breakdown by Continent 
SELECT continent, MAX(CAST(total_deaths AS INT)) as TotalDeathCount 
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
order by TotalDeathCount DESC

-- -- Breakdown by Continent with more accurate figure
SELECT location, MAX(CAST(total_deaths AS INT)) as TotalDeathCount 
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- GLOBAL NUMBERS
SELECT SUM(new_cases) as total_cases, 
SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM CovidDeaths
--Where location like '%states%'
WHERE continent is not null 
--Group By date
ORDER BY 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations 
FROM CovidDeaths as cd
JOIN CovidVaccinations as cv
ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL 
ORDER BY 2,3

SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CAST(cv.new_vaccinations AS INT)) OVER (PARTITION BY cd.location)
FROM CovidDeaths as cd
JOIN CovidVaccinations as cv
ON cd.location = cv.location AND cd.date = cv.date
WHERE cd.continent IS NOT NULL 
ORDER BY 2,3
