{% macro test_nested_not_null(model, column_name, path) -%}
	WITH validation AS
		{{ test_helper_build_query_unnested_path(path|default(column_name),model) }},

	validation_errors AS (
		SELECT *
		FROM validation
		WHERE source IS NULL
	)

	SELECT COUNT(*)
	FROM validation_errors
{% endmacro %}

