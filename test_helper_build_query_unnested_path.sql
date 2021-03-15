{% macro test_helper_build_query_unnested_path(path, model, output_field, extra_fields) -%}
	{% if path is string %}
		{% set path = path.replace('[].','[]') %}
		{% set path = path.split('[]') %}
	{% endif %}
	(
		SELECT
			stage{{ path|length-1 }}{% if path|last != '' %}.{{path|last}}{% endif %} AS {{ output_field|default("source") }},
			{{extra_fields}}
		FROM {{ model }} AS stage0
		{% for f in path %}
			-- {{ f }}
			{% if not loop.last %}
				CROSS JOIN UNNEST(stage{{ loop.index-1 }}{% if f != '' %}.{{f}}{% endif %}) AS stage{{ loop.index }}
			{% endif %}
		{% endfor %}
	)
{% endmacro %}
