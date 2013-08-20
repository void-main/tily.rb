#!/usr/bin/env ruby
require 'rmagick'
require 'FileUtils'
require 'json'
require_relative './tily/utils/tile_system'

include Magick

module Tily
	class Tily
		attr_accessor :raw_image
		attr_accessor :output_path
		attr_accessor :ts
		attr_accessor :background_color

		def initialize opts
			img_path = opts[:img_path]
			output_path = opts[:output_path]
			unit_size = opts[:unit_size] || 256
			background_color = opts[:bg_color] || "grey"

			@raw_image = ImageList.new img_path
			@output_path = output_path
			@ts = TileSystem.new unit_size
			@ts.read_raw_dimension @raw_image.columns, @raw_image.rows
			@background_color = background_color

			FileUtils.mkdir_p @output_path unless Dir.exists? @output_path
		end

		def gen_tiles
			norm_size = @ts.normalized_size
			base_img = Image.new(norm_size, norm_size) { self.background_color = "grey" }
			base_img = base_img.composite(@raw_image, GravityType::CenterGravity, CompositeOperator::CopyCompositeOp)

			puts "Generating meta-data..."
			File.open("#{@output_path}/meta.json", "w") {|f| f.write(@ts.meta.to_json) }
			puts "Done."

			puts "Generating images..."

			@ts.each_level do |level|
				puts "Level #{level}:"

				level_folder = "#{@output_path}/#{level}"
				FileUtils.mkdir_p level_folder unless Dir.exists? level_folder

				level_size = @ts.level_size level
				level_img  = base_img.resize level_size, level_size

				@ts.each_tile_with_index(level) do |x, y, index|
					tile_img = level_img.crop(@ts.tile_offset(x), @ts.tile_offset(y), @ts.unit_size, @ts.unit_size)
					tile_img.write("#{level_folder}/#{@ts.quadkey(level, x, y)}.png")
				end

				puts "Done."
			end

			puts "Tiles generated to folder '#{@output_path}'..."
		end

		private
		# Format a beautiful hint string
		def processing_hint_str number, level
			total = (@ts.tile_size(level) ** 2).to_s
			now   = (number + 1).to_s.rjust(total.length, " ")
			"#{now}/#{total}"
		end
	end
end
