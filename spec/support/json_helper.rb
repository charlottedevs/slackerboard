def json_data(filename:)
  file_content = file_fixture("#{filename}.json").read
  JSON.parse(file_content).with_indifferent_access
end
