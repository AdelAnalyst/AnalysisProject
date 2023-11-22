select *
from PortfolioProject..CovidDeaths

select *
from PortfolioProject..CovidDeaths
order by 3,4

--select the data that we are going to be using
select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths2
order by 1,2

--looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths2
order by 1,2

--looking at total cases vs total deaths
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths2
where location like '%state%'
order by 1,2

--totalcases vs population
--showa what percentage of population 
select location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from PortfolioProject..CovidDeaths2
where location like '%tanzania%'
order by 1,2

--looking for countries with highest infection rate compared to population
select location, date, total_cases, population, (total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject..CovidDeaths2
where location like '%tanzania%'
order by 1,2

--looking for countries with highest infection rate compared to population
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as 
MaxPercentagePopulationInfected
from PortfolioProject..CovidDeaths2
select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as 
MaxPercentagePopulationInfected
from PortfolioProject..CovidDeaths2
--where location like '%tanzania%'
group by Location, POPULATION
order by MaxPercentagePopulationInfected desc
group by Location, POPULATION
order by MaxPercentagePopulationInfected desc

--showing countries with highest death count per population
select location, max(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths2
group by Location
order by TotalDeathCount asc

--showing countries with highest death count per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths2
group by Location
order by TotalDeathCount desc

--showing countries with highest death count per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths2
--where location like '%world%' and continent is not null
where continent is not null
group by Location
order by TotalDeathCount desc

--let's break things down by continent

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths2
--where location like '%world%' and continent is not null
where continent is not null
group by continent
order by TotalDeathCount desc

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths2
--where location like '%world%' and continent is not null
where continent is null
group by location
order by TotalDeathCount desc

--global numbers

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths2
--where location like '%state%'
where continent is not null
order by 1,2

select date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths2
--where location like '%state%'
where continent is not null
order by 1,2

select date, sum(new_cases)--total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths2
--where location like '%state%'
where continent is not null
group by date
order by 1,2

select date, sum(new_cases) as SumOfNewCases, sum(cast(new_deaths as int)) as SumOfNewDeaths--total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths2
--where location like '%state%'
where continent is not null
group by date
order by 1,2

select date, sum(new_cases) as SumOfNewCases, sum(cast(new_deaths as int)) as SumOfNewDeaths--total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths2
--where location like '%state%'
where continent is not null
group by date
order by 1,2


select date, sum(new_cases) as SumOfNewCases, sum(cast(new_deaths as int)) as SumOfNewDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100
as DeathPercentage
from PortfolioProject..CovidDeaths2
--where location like '%state%'
where continent is not null
group by date
order by 1,2

--Looking at Total Population vs Vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths2 dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
from PortfolioProject..CovidDeaths2 dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--use cte
with cte as
(
--showing countries with highest death count per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths2
group by Location
order by TotalDeathCount desc
)

select *
from cte

--temp tables
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into
#PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date)
from PortfolioProject..CovidDeaths2 dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *
from #PercentPopulationVaccinated