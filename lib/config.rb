module ConfigVars
	class_variable_set(:@@tile_size, 256)

	def self.tile_size
		return @@tile_size
	end
end