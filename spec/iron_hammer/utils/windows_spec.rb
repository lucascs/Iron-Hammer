require 'iron_hammer/utils/windows'

module IronHammer
  module Utils
    describe Windows do
      it 'should patheticalize an array, putting windows backslash as the separator' do
        ['a', 'b', 'c'].patheticalize.should be_eql('a\\b\\c')
      end
      
      it 'should return an empty string if an empty array is given' do
        [].patheticalize.should be_eql('')
      end
      
      it 'should work even for arrays with just one element' do
        ['marvin'].patheticalize.should be_eql('marvin')
      end
      
      it 'should patheticalize a string' do
        'a/b/c/d\\e'.patheticalize.should be_eql('a\\b\\c\\d\\e')
      end
    end
  end
end
