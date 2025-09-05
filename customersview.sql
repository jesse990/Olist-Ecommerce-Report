USE [ecommerce]
GO

/****** Object:  View [dbo].[customer_dim2]    Script Date: 05/09/2025 11:20:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[customer_dim2] AS
WITH customers AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_unique_id
                                 ORDER BY customer_zip_code_prefix) AS rn
    FROM ecommerce.dbo.olist_customers_dataset
),
base AS (
    SELECT customer_unique_id,
           customer_city,
           customer_zip_code_prefix,
           CASE customer_state
        WHEN 'AC' THEN 'Acre'
        WHEN 'AL' THEN 'Alagoas'
        WHEN 'AP' THEN 'Amapá'
        WHEN 'AM' THEN 'Amazonas'
        WHEN 'BA' THEN 'Bahia'
        WHEN 'CE' THEN 'Ceará'
        WHEN 'DF' THEN 'Distrito Federal'
        WHEN 'ES' THEN 'Espírito Santo'
        WHEN 'GO' THEN 'Goiás'
        WHEN 'MA' THEN 'Maranhão'
        WHEN 'MT' THEN 'Mato Grosso'
        WHEN 'MS' THEN 'Mato Grosso do Sul'
        WHEN 'MG' THEN 'Minas Gerais'
        WHEN 'PA' THEN 'Pará'
        WHEN 'PB' THEN 'Paraíba'
        WHEN 'PR' THEN 'Paraná'
        WHEN 'PE' THEN 'Pernambuco'
        WHEN 'PI' THEN 'Piauí'
        WHEN 'RJ' THEN 'Rio de Janeiro'
        WHEN 'RN' THEN 'Rio Grande do Norte'
        WHEN 'RS' THEN 'Rio Grande do Sul'
        WHEN 'RO' THEN 'Rondônia'
        WHEN 'RR' THEN 'Roraima'
        WHEN 'SC' THEN 'Santa Catarina'
        WHEN 'SP' THEN 'São Paulo'
        WHEN 'SE' THEN 'Sergipe'
        WHEN 'TO' THEN 'Tocantins'
           END                            AS CusState,
           Rscore, Fscore, Mscore, RFMscore, customercategory
    FROM customers
    WHERE rn = 1
),
base1 AS (
    SELECT *,
           CONCAT(customer_zip_code_prefix, customer_city, CusState) AS geoid
    FROM base
),
rows1 AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_unique_id
                                 ORDER BY geoid) AS row_geo
    FROM base1
),
base2 AS (
    SELECT  b.*,
            g.geolocation_lat AS lat,
            g.geolocation_lng AS lng
    FROM rows1 b
    LEFT JOIN ecommerce.dbo.olist_geolocation_dataset g
           ON b.geoid = g.geoid
    WHERE row_geo = 1
)
SELECT customer_unique_id,
       customer_city,
       customer_zip_code_prefix,
       CusState,
       geoid,
       row_geo,
       Rscore, Fscore, Mscore, RFMscore, customercategory,
       lat, lng
FROM base2;
GO

