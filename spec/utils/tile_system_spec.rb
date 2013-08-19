require 'spec_helper'

describe Tily::TileSystem do
  before :each do
    # Set unit_size to 256
    @ts = Tily::TileSystem.new 256
    @ts.read_raw_dimension 3824, 3904
  end

  it 'should create binary string filling 0s in the beginning' do
    1.bin_str(3).should == "001"
  end

  it 'should wrap width to "256 * 2 ** level"' do
    @ts.normalized_size.should == 4096
  end

  it 'should tell max level correctly' do
    @ts.max_level.should == 4
  end

  it 'should calculate tile size correctly' do
    @ts.tile_size(4).should == 2 ** 4
  end

  it 'should calculate tile offset correctly' do
    @ts.tile_offset(2).should == 512
  end

  it 'should calculate quadkey correctly' do
    @ts.quadkey(3, 3, 5).should == "213"
  end

  it 'should iterate through all levels' do
    levels = []
    @ts.each_level {|level| levels << level }
    levels.should == [1, 2, 3, 4]
  end

  it 'should iterate through all tiles of a level' do
    tiles = []
    @ts.each_tile(3) {|x, y| tiles << [x, y]}
    tiles.length.should == 64
  end
end