use PortfolioProject;

select * from CovidDeaths$

--Looking at Total Cases vs Total Deaths

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 
as Percentage_of_cases_and_deaths
from CovidDeaths$ 
where continent is not null
order by 1,2



--Looking at Total Cases vs Total Deaths in India

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 
as Percentage_of_cases_and_deaths
from CovidDeaths$ 
where location='India'
order by 1,2



--Looking at Total Cases vs Population
--Shows what percent of population got Covid

Select location,date,Population,total_cases,total_deaths,(total_deaths/population)*100 
as PercentagePopulationInfected
from CovidDeaths$ 
where location='India'



--Looking at Countries with Highest Infection Rate compared to Population

Select location,date,Population,Max(total_cases) as TotalCases,Max(total_cases/population)*100 
as PercentagePopulationInfected
from CovidDeaths$ 
Group by location,population,date
order by PercentagePopulationInfected desc



--Showing Countries with Highest Death count per Population

Select location,Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths$ 
where continent is not null
Group by location
order by TotalDeathCount desc



--Showing Countries with Highest Death count per Population by Continent

Select continent,Max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths$ 
where continent is not null
Group by continent
order by TotalDeathCount desc



--Global Numbers

Select Date,SUM(new_cases) as Total_Cases,SUM(cast(new_deaths as int)) as Total_Deaths,
SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths$
where continent is not null
group by date
order by 1,2



--Looking at Total Population Vs Vaccination

select dea.continent,dea.location,dea.date,dea.new_vaccinations,dea.population,
SUM(cast(vac.new_vaccinations as int)) 
OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths$ dea 
join CovidVaccinations$ vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

--Using CTE

With PopVsVacs(continent,location,date,new_vaccinations,population,RollingPeopleVaccinated)
as
(
	select dea.continent,dea.location,dea.date,dea.new_vaccinations,dea.population,
	SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
	from CovidDeaths$ dea join CovidVaccinations$ vac on dea.location=vac.location and dea.date=vac.date
	where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population) * 100 as VaccinatedPeoplePercentage
from PopVsVacs



--Creating View

create view PercentagePopulationInfected as
select dea.continent,dea.location,dea.date,dea.new_vaccinations,dea.population,
SUM(cast(vac.new_vaccinations as int)) 
OVER (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from CovidDeaths$ dea 
join CovidVaccinations$ vac on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null

select * from PercentagePopulationInfected














