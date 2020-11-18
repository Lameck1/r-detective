require_relative '../lib/get_offence.rb'

describe GetOffence do
  let(:detective) { GetOffence.new('./test_files/code_smells.rb') }
  let(:bad_name_detective) { GetOffence.new('./test_files/BadName.rb') }
  let(:too_long_detective) { GetOffence.new('./test_files/too_long.rb') }

  describe '#detect_bad_comment_syntax' do
    it 'returns a bad comment syntax error at line:11 col:0' do
      detective.detect_bad_comment_syntax
      expect(detective.offences[0]).to eq('line:11:0: Bad comment syntax.')
    end
  end

  describe '#detect_bad_file_name' do
    it 'returns file name syntax error' do
      bad_name_detective.detect_bad_file_name
      expect(bad_name_detective.offences[0]).to eq('Bad file name: Use snake_case for naming files.')
    end
  end

  describe '#detect_proc_new_usage' do
    it 'recommends proper usage of `proc` at line:4 col:11' do
      detective.detect_proc_new_usage
      expect(detective.offences[0]).to eq('line:4:11: Use `proc` instead of `Proc.new`.')
    end
  end

  describe '#detect_trailing_empty_lines' do
    it 'returns trailing empty lines error at found at EOF' do
      detective.detect_trailing_empty_lines
      expect(detective.offences[0]).to eq('Trailings empty lines at EOF, only one empty line expected at end of file.')
    end
  end

  describe '#detect_source_file_too_long' do
    it 'returns source file too long error' do
      too_long_detective.detect_source_file_too_long
      expect(too_long_detective.offences[0]).to eq('Source file too long, total lines should be < 100.')
    end
  end

  describe '#detect_leading_empty_lines' do
    it 'returns leading empty lines error at found at Beginning of file' do
      detective.detect_leading_empty_lines
      expect(detective.offences[0]).to eq('Leading empty lines detected at beginning of file.')
    end
  end

  describe '#detect_double_spaces' do
    it 'returns double space error at line:2 col:0' do
      detective.detect_double_spaces
      expect(detective.offences[0]).to eq('line:2:0: Double spaces detected.')
    end
  end

  describe '#detect_trailing_spaces' do
    it 'returns trailing whitesapce error at line:8 col:19' do
      detective.detect_trailing_spaces
      expect(detective.offences[0]).to eq('line:8:19: Trailing whitespace detected.')
    end
  end
end
