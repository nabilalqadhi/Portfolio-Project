/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project | SQL Data Exploration]..CovidDeath
Where continent is not null 
order by 1,2



-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country 

Select Location, date, total_cases,cast(total_deaths as decimal), (cast(total_deaths as decimal)/total_cases)*100 as DeathPercentage
From [Portfolio Project | SQL Data Exploration]..CovidDeath
Where location like '%Yemen%'
and continent is not null 
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From [Portfolio Project | SQL Data Exploration]..CovidDeath
Where location like '%Yemen%'
order by 1,2




-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [Portfolio Project | SQL Data Exploration]..CovidDeath

Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From  [Portfolio Project | SQL Data Exploration]..CovidDeath
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Project | SQL Data Exploration]..CovidDeath
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project | SQL Data Exploration]..CovidDeath dea
Join [Portfolio Project | SQL Data Exploration]..covidvaccine vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3



-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project | SQL Data Exploration]..CovidDeath dea
Join [Portfolio Project | SQL Data Exploration]..covidvaccine vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


--  Query the created view

select * from PercentPopulationVaccinated
