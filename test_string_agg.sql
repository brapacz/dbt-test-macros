{% macro test_string_agg(model, column_name, path, separator) -%}
	WITH
	validation AS (
		SELECT
			{{column_name}} AS _EXPECTED_VALUE,
			ARRAY(
				{{ test_helper_build_query_unnested_path(path, model="UNNEST([_INPUT_ROW])") }}
				) AS _SOURCE_VALUES
		FROM {{model}} AS _INPUT_ROW
	),
	validation_errors AS (
		SELECT *
		FROM validation
		WHERE ARRAY_TO_STRING(_SOURCE_VALUES, {{separator|tojson}}) != _EXPECTED_VALUE
	)

	SELECT COUNT(*)
	FROM validation_errors
{% endmacro %}

