collection @items, :object_root => false
node(:id){ |item| item[:id] }
node(:title){ |item| item[:title] }
node(:popular){ |item| item[:popular] }
node(:type){ |item| item[:type] }
node(:image) { |item| item[:images].where(is_main_image: true, approved: true).first }
