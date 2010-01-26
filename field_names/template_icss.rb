
require 'wukong'

Dataset = Struct.new(
  :title,
  :subtitle,
  # and so forth
  :license,
  :tables
)
Dataset.class_eval do
  
  def num_tables
    tables.length
  end

# += ||= 
# a ||=  b
# a = a || b
  
  def license_handle= license_handle
    self.license ||= License.new()
    self.license.handle = license_handle
  end
end

Table = Struct.new(
  :a,
  :b,
  :c
)

@dataset = Dataset.new( "hi mom", "subtitle", [1,2,3])


p @dataset[:title]
p @dataset.title
p @dataset['title']

p @dataset.values_of(:title, :tables)

@dataset.tables << Table.new(1,2,3)



@dataset.merge!({
  :title => 'tt',
  :subtitle => 'st',
  :license_title => 'lt',
})

p @dataset