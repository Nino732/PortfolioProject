SELECT *
FROM [Portfolio Project]..CovidDeaths$
Where continent is not null
order by 3,4 


Select Location,Population,MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths$
Group by Location, Population
order by PercentPopulationInfected desc

Select location,MAX(cast(total_deaths as int))as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths$
Where Continent is null
Group by location
order by TotalDeathCount desc

Select continent,MAX(cast(total_deaths as int))as TotalDeathCount
FROM [Portfolio Project]..CovidDeaths$
Where Continent is not null
Group by continent
order by TotalDeathCount desc

Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM (cast
(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths$
Where continent is not null
order by 1,2

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM (CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
ON dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

With PopvsVac (Continent,Location,Date,Population, New_Vaccinations,RollingPeopleVaccinated)
as 
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM (CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
ON dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null
)

Select*, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac 







DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert Into #PercentPopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
ON dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null

Select*, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated



Create View PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
, SUM(CONVERT (int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
FROM [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
ON dea.location= vac.location
and dea.date = vac.date
where dea.continent is not null

