#!/usr/bin/env ruby
require 'rmagick'
require 'FileUtils'

require_relative 'pixel_level'
require_relative 'config'

include Magick

img_path = "/Users/voidmain/Desktop/el-mundo.jpg"
target_path = "#{Dir.home()}/Desktop/el-mundo"

# Expands (or possibly shrinks) the image size to 
# tile_size * (2 ** n)
# returns the modified image size
def target_level img
	[img.columns.to_level, img.rows.to_level].max
end

# Calculate QuadKey for tile (<x>, <y>) in <level>
def quadkey level, x, y
	x_chars = x.to_binary_str(level).split ""
	y_chars = y.to_binary_str(level).split ""

	y_chars.zip(x_chars).flatten.join("").to_i(2).to_s(4).rjust(level, "0")
end

def processing_hint_str number, level
	total = (level.to_tile ** 2).to_s
	now   = number.to_s.rjust(total.length, " ")
	"#{now}/#{total}"
end

img = ImageList.new img_path
level = target_level img
size = level.to_pixel
base_img = Image.new(size, size) { self.background_color = "grey" }
base_img = base_img.composite img, GravityType::CenterGravity, CompositeOperator::CopyCompositeOp

# start generating images
puts "Generating images..."

(1..level).each do |cur_level|
	level_folder = "#{target_path}/#{cur_level}"
	FileUtils.mkdir_p level_folder unless Dir.exists? level_folder

	level_size = cur_level.to_pixel
	level_img  = base_img.resize level_size, level_size
	cur_tile   = 0

	puts "Level #{cur_level} :"

	(0...cur_level.to_tile).each do |y|
		(0...cur_level.to_tile).each do |x|
			cur_tile += 1
			print "Processing image: #{processing_hint_str(cur_tile, cur_level)}\r"
			$stdout.flush
			
			tile_img = level_img.crop(x.to_pixel_offset, y.to_pixel_offset, ConfigVars.tile_size, ConfigVars.tile_size)
			tile_img.write("#{level_folder}/#{quadkey(cur_level, x, y)}.png")
		end
	end
	puts "\n"
	puts "Done."
end