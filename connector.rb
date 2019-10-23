{
  title: "Open Skills API",
  connection: {
    fields: [],
    authorization: {
      type: "custom_auth"
    },
    base_uri: lambda do |_connection|
      "http://api.dataatwork.org"
    end
  },
  test: lambda do |_connection|
    true
  end,
  actions: {
    normalize_job_title: {
      input_fields: lambda do |_object_definitions|
        [
          {
            name: "job_title",
            optional: false
          },
          {
            name: "limit",
            hint: "Defaults to 1 result"
          }
        ]
      end,
      execute: lambda do |connection, input|
        {
          "results": get("/v1/jobs/normalize").params(input)
        }
      end,
      output_fields: lambda do |object_definitions|
        [
          {
            name: "results",
            type: :array,
            of: :object,
            properties: [
              { name: "uuid" },
              { name: "title" },
              { name: "relevance_score" },
              { name: "parent_uuid" }
            ]
          }
        ]
      end
    },
    get_related_skills: {
      help: "Get related skills to the job found from the 'Normalize job title' action.",
      input_fields: lambda do |_object_definitions|
        [
          {
            name: "job_id",
            optional: false
          }
        ]
      end,
      execute: lambda do |connection, input|
        get("/v1/jobs/#{input["job_id"]}/related_skills")
      end,
      output_fields: lambda do |_object_definitions|
        [
          {
            "control_type": "text",
            "label": "Job uuid",
            "type": "string",
            "name": "job_uuid"
          },
          {
            "control_type": "text",
            "label": "Job title",
            "type": "string",
            "name": "job_title"
          },
          {
            "control_type": "text",
            "label": "Normalized job title",
            "type": "string",
            "name": "normalized_job_title"
          },
          {
            "name": "skills",
            "type": "array",
            "of": "object",
            "label": "Skills",
            "properties": [
              {
                "control_type": "text",
                "label": "Skill uuid",
                "type": "string",
                "name": "skill_uuid"
              },
              {
                "control_type": "text",
                "label": "Skill name",
                "type": "string",
                "name": "skill_name"
              },
              {
                "control_type": "text",
                "label": "Description",
                "type": "string",
                "name": "description"
              },
              {
                "control_type": "text",
                "label": "Normalized skill name",
                "type": "string",
                "name": "normalized_skill_name"
              },
              {
                "control_type": "number",
                "label": "Importance",
                "parse_output": "float_conversion",
                "type": "number",
                "name": "importance"
              },
              {
                "control_type": "number",
                "label": "Level",
                "parse_output": "float_conversion",
                "type": "number",
                "name": "level"
              }
            ]
          }
        ]
      end
    }
  }
}
