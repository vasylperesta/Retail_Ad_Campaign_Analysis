--HOMEWORK_1

select
	ad_date,
	spend,
	clicks,
	spend / clicks as spend_to_clicks
from
	facebook_ads_basic_daily
where
	clicks > 0
order by
	ad_date desc
;

select
	campaign_id ,
	impressions ,
	leads
from
	facebook_ads_basic_daily
where
	impressions > 100000 and leads > 0
order by 
	leads desc  
;
select
	ad_date,
	campaign_id, 
	sum (spend) total_spend
from
	facebook_ads_basic_daily
	where ad_date is not null 
group by 
ad_date ,
campaign_id;

--HOMEWORK_2

select
	ad_date,
	campaign_id,
	sum (spend) total_spend,
	sum(impressions) total_impression,
	sum (clicks) total_clicks,
	sum (value) total_value,
	round (sum (spend) :: numeric / sum (clicks) :: numeric,
	2) CPC,	
	round (1000 * (sum (impressions) :: numeric / sum (spend) :: numeric),
	2) CPM,
	round (100 * sum (clicks) :: numeric / sum (impressions) :: numeric,
	2) CTR,
	round (100 *(sum (value) :: numeric - sum (spend)) / sum (spend) :: numeric,
	2) ROMI
from
	facebook_ads_basic_daily
where
	ad_date is not null
	and true
	and clicks <> 0
group by
	ad_date ,
	campaign_id;

select  
	campaign_id,
	sum (spend) total_spend,
	sum (value) total_value,
	round (100 *(sum (value) :: numeric - sum (spend)) / sum (spend) :: numeric, 2) ROMI
from
	facebook_ads_basic_daily
where
	true
	and spend <> 0
group by
	campaign_id
having 
	sum (spend) > 500000
order by
	romi desc
limit 1

--HOMEWORK_3

select
	ad_date,
	'Facebook_Ads' as media_source,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
from
	facebook_ads_basic_daily fabd
union all 
select
	ad_date,
	'Google_Ads' as media_source,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
from
	google_ads_basic_daily gabd
order by
	ad_date;

select
	ad_date,
	'Facebook_Ads' as media_source,
	sum (spend) as ttl_spend,
	sum(impressions) as ttl_impr,
	sum(clicks) as ttl_clicks,
	sum(value) as ttl_value
from
	facebook_ads_basic_daily fabd
group by
	ad_date,
	media_source
union all 
select
	ad_date,
	'Google_Ads' as media_source,
	sum (spend) as ttl_spend,
	sum(impressions) as ttl_impr,
	sum(clicks) as ttl_clicks,
	sum(value) as ttl_value
from
	google_ads_basic_daily gabd
group by
	ad_date,
	media_source;

--HOMEWORK_4

with marketing_sources as (
select
	fabd.ad_date,
	fc.campaign_name,
	fa.adset_name,
	'Facebook_Ads' as media_source,
	fabd.spend,
	fabd.impressions,
	fabd.reach,
	fabd.clicks,
	fabd.leads,
	fabd.value
from
	facebook_ads_basic_daily fabd
left join facebook_campaign fc 
on
	fabd.campaign_id = fc.campaign_id
left join facebook_adset fa 
on
	fabd.adset_id = fa.adset_id
where
	ad_date is not null
union all
select
	ad_date,
	campaign_name,
	adset_name,
	'Google_Ads' as media_source,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
from
	google_ads_basic_daily)
select
	ad_date,
	media_source,
	campaign_name,
	adset_name,
	sum(spend) as ttl_spend,
	sum(impressions) as ttl_impr,
	sum(clicks) as ttl_clicks,
	sum(value) as ttl_value
from
	marketing_sources
where 
	spend <> 0
group by
	ad_date,
	media_source,
	campaign_name,
	adset_name
  

--	BONUS 1

with marketing_sources as (
select
	fabd.ad_date,
	fc.campaign_name,
	fa.adset_name,
	'Facebook_Ads' as media_source,
	fabd.spend,
	fabd.impressions,
	fabd.reach,
	fabd.clicks,
	fabd.leads,
	fabd.value
from
	facebook_ads_basic_daily fabd
left join facebook_campaign fc 
on
	fabd.campaign_id = fc.campaign_id
left join facebook_adset fa 
on
	fabd.adset_id = fa.adset_id
where
	ad_date is not null
union all
select
	ad_date,
	campaign_name,
	adset_name,
	'Google_Ads' as media_source,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
from
	google_ads_basic_daily)
select
	campaign_name,
	sum(spend) as ttl_spend,
	round (100 *(sum (value) :: numeric - sum (spend)) / sum (spend) :: numeric,
	2) ROMI
from
	marketing_sources
where 
	spend <> 0
group by
	campaign_name
having
	sum(spend) > 500000
order by
	romi desc
limit 1

--		BONUS 2
 
with marketing_sources as (
select
	fabd.ad_date,
	fc.campaign_name,
	fa.adset_name,
	'Facebook_Ads' as media_source,
	fabd.spend,
	fabd.impressions,
	fabd.reach,
	fabd.clicks,
	fabd.leads,
	fabd.value
from
	facebook_ads_basic_daily fabd
left join facebook_campaign fc 
on
	fabd.campaign_id = fc.campaign_id
left join facebook_adset fa 
on
	fabd.adset_id = fa.adset_id
where
	ad_date is not null
union all
select
	ad_date,
	campaign_name,
	adset_name,
	'Google_Ads' as media_source,
	spend,
	impressions,
	reach,
	clicks,
	leads,
	value
from
	google_ads_basic_daily)
select
	adset_name,
	sum(spend) as ttl_spend,
	round (100 *(sum (value) :: numeric - sum (spend)) / sum (spend) :: numeric,
	2) ROMI
from
	marketing_sources
where 
	spend <> 0
	and 
	campaign_name = 'Promos'
group by
	adset_name
having
	sum(spend) > 500000
order by
	romi desc
limit 1


	 
