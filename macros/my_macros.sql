{%macro usd_eur (col,scale=8)%}
    ({{ col}} * 0.86)::numeric(32, {{ scale }})
{% endmacro %}



