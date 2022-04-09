use covidproject
go

select * from dbo.coviddeaths
where continent is null

--Total death % country wise

select location,date,total_cases,total_deaths,round(((total_deaths/total_cases)*100),2) as deathpercentage
from dbo.coviddeaths
where continent is not null
--where location like '%states%'
order by deathpercentage desc

--Total Cases Vs population

select location,date,population,total_cases,round(((total_cases/population)*100),2) as percentagecases
from dbo.coviddeaths
where continent is not null
--where location like'%states%'
order by 1,2

--Highest infection rate country Vs population

select location,population,max(total_cases) as highestinfectionrate,max(round(((total_cases/population)*100),2)) as percentageinfectionrate
from dbo.coviddeaths
where continent is not null
group by location,population
order by percentageinfectionrate desc

--Showing countries with highest death count per population

select location, max(cast(total_deaths as int)) as highestdeaths, max(round(((total_deaths/population)*100),2)) as percentagedeaths from dbo.coviddeaths
where continent is not null
group by location
order by highestdeaths desc

--Showing the highest deaths by continent

select continent,max(cast(total_deaths as int)) as highestdeaths from dbo.coviddeaths
where continent is not null
group by continent
order by highestdeaths desc

select * from dbo.coviddeaths
where continent is not null

--Total deaths according to the date worldwide

select date,sum(new_cases) as totalcases,SUM(cast(new_deaths as int)) as totaldeaths, round(SUM(cast(new_deaths as int))*100/sum(new_cases),2) as percentagedeath
from dbo.coviddeaths
where continent is not null
group by date
order by 1,2

--Total Death Till 04-04-2022

select sum(new_cases) as totalcases,SUM(cast(new_deaths as int)) as totaldeaths, round(SUM(cast(new_deaths as int))*100/sum(new_cases),2) as percentagedeath
from dbo.coviddeaths
where continent is not null
--group by date
order by 1,2

--Total vaccination Vs Population

with vacVspop (continent,location,date,population,new_vaccination,rollingpeoplevaccinated)
as
(
select dbo.coviddeaths.continent,dbo.coviddeaths.location,dbo.covidvaccination.date, dbo.coviddeaths.population,dbo.covidvaccination.new_vaccinations,
sum(cast(dbo.covidvaccination.new_vaccinations as bigint)) over (partition by dbo.coviddeaths.location order by dbo.coviddeaths.location,dbo.coviddeaths.date) as rollingpeoplevaccinated
from dbo.coviddeaths
join dbo.covidvaccination
on dbo.coviddeaths.location=dbo.covidvaccination.location
and
coviddeaths.date=covidvaccination.date
where dbo.coviddeaths.continent is not null 
)
select *,(rollingpeoplevaccinated/population*100) as rollingpercentage from vacVspop



--Join the tables

select * from dbo.coviddeaths
left join dbo.covidvaccination
on dbo.coviddeaths.location=dbo.covidvaccination.location
and
coviddeaths.date=covidvaccination.date
where dbo.coviddeaths.continent is not null 
--where dbo.coviddeaths.continent='%africa%'








