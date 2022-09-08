USE Covid_data;
SHOW TABLES;

DESCRIBE coviddeaths;


-- looking at total cases vs total deaths
-- likelyhood of dying if you got covid in your country 
 
SELECT location, date, total_cases, total_deaths , (total_deaths/total_cases)*100 as DeathPercentage
FROM coviddeaths
order by 1,2;



 -- looking at total cases vs population
 -- shows what percentage of population got covid 
SELECT location, date ,population , total_cases,  (total_cases/population)*100 as PercentagePopuletionInfected
FROM coviddeaths

order by 1,2;


 -- looking at Countries with Highest infection rate vs population
SELECT location, population , MAX(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as PercentagePopuletionInfected
FROM coviddeaths
group by location, population
order by PercentagePopuletionInfected desc;


-- showing countries with the highest death count per population
SELECT location, MAX(CAST(total_deaths AS DECIMAL)) as TotalDeathCount
FROM coviddeaths
WHERE continent is not null
group by location
order by TotalDeathCount desc; 

-- showing CONTINENTS with the highest death count per population
SELECT continent , MAX(CAST(total_deaths AS DECIMAL)) as TotalDeathCount
FROM coviddeaths
where continent is not null
Group by continent
Order by TotalDeathCount desc; 

-- Global numbers
SELECT SUM(new_cases) as total_cases , SUM(CAST(new_deaths AS DECIMAL)) as total_deaths, SUM(CAST(new_deaths AS DECIMAL))/SUM(new_cases)*100 as DeathPercentage
FROM coviddeaths
where continent is not null 
order by 1,2;


-- total population vs vaccinations 
DESCRIBE covidvaccinations;
-- USE CTE 
with PopvsVAC(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as (
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST( vac.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
 
FROM coviddeaths dea 
JOIN covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
SELECT *, (RollingPeopleVaccinated/Population)*100
From PopvsVac;

-- TEMP TABLE 

DROP TABLE PrecentPopulationVaccinated;
CREATE TABLE PrecentPopulationVaccinated( 
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric);
INSERT INTO PrecentPopulationVaccinated


SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST( vac.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
 
FROM coviddeaths dea 
JOIN covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null; 

SELECT *, (RollingPeopleVaccinated/Population)*100
From PrecentPopulationVaccinated;


-- creating View to store data for visualization 

CREATE VIEW PrecentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
SUM(CAST( vac.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinatedcovidvaccinations
FROM coviddeaths dea 
JOIN covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null;