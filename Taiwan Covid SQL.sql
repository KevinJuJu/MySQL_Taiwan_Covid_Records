SELECT * FROM Project_Covid.coviddeaths
order by 4;

SELECT * FROM Project_Covid.covidvaccinations
order by 4;

-- Total cases vs Total deaths
-- Shows likelihood of dying in Taiwan
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Project_Covid.coviddeaths
order by 2;

-- Total cases vs Population
-- Shows what percentage of population infected with Covid
Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From Project_Covid.coviddeaths
order by 2;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Project_Covid.coviddeaths dea
Join Project_Covid.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
order by 2,3;

-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From Project_Covid.coviddeaths dea
Join Project_Covid.covidvaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)
From PopvsVac


