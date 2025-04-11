WITH dim_date_generate AS (
  SELECT
    *
  FROM UNNEST(GENERATE_DATE_ARRAY('2010-01-01', '2030-12-31', INTERVAL 1 DAY)) AS date
)

  SELECT
    *,

    -- Tên ngày đầy đủ (Monday, Tuesday)
    FORMAT_DATE('%A', date) AS day_of_week,

    -- Tên ngày viết tắt (Mon, Tue)
    FORMAT_DATE('%a', date) AS day_of_week_short,

    -- Phân biệt weekday và weekend
    CASE 
      WHEN EXTRACT(DAYOFWEEK FROM date) IN (1, 7) THEN 'Weekend'
      ELSE 'Weekday'
    END AS is_weekday_or_weekend,

    -- Truncate về đầu tháng
    DATE_TRUNC(date, MONTH) AS year_month,

    -- Tên tháng (January, February)
    FORMAT_DATE('%B', date) AS month,

    -- Truncate về đầu năm
    DATE_TRUNC(date, YEAR) AS year,

    -- Năm dạng số (2022)
    EXTRACT(YEAR FROM date) AS year_number

  FROM dim_date_generate

