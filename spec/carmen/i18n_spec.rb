require 'spec_helper'

describe 'Carmen I18n defaults' do

  it "sets an instance of I18n::Simple as the default backend" do
    backend = Carmen.i18n_backend

    backend.instance_of?(Carmen::I18n::Simple).must_equal true
  end

end

describe "I18n::Simple" do

  before do
    path = File.expand_path('../../locale', __FILE__)
    @i18n = Carmen::I18n::Simple.new(path)
  end

  it "loads and merges yaml files" do
    @i18n.t('world.oc.name').must_equal 'Oceania'
    @i18n.t('world.oc.ao.name').must_equal 'Airstrip One'
    @i18n.t('world.oc.ao.lo.name').must_equal 'London'
  end

  describe "overlaying additional locale paths" do

    before do
      @i18n.append_locale_path(File.expand_path('../../overlay/locale', __FILE__))
    end

    after do
      @i18n.locale_paths.pop
      @i18n.reset!
    end

    it 'can override the names of countries' do
      @i18n.t('world.es.official_name').must_equal('The Wonderous Country of Eastasia')
    end

    it 'can override the names of subregions' do
      @i18n.t('world.oc.ao.name').must_equal('Airstrip Uno')
    end
  end

  describe 'using a non-default locale' do
    before do
      @i18n.append_locale_path(File.expand_path('../../overlay/locale', __FILE__))
      @i18n.locale = 'zz'
    end

    after do
      @i18n.locale = Carmen::I18n::Simple::DEFAULT_LOCALE
      @i18n.reset!
    end

    it 'can override the names of countries' do
      @i18n.t('world.es.official_name').must_equal('The Zonderous Zountry of Zeastasia')
    end

    it 'can override the names of subregions' do
      @i18n.t('world.oc.ao.name').must_equal('Zairstrip Zuno')
    end

    it 'falls back when a a locale is missing a value' do
      @i18n.t('world.eu.official_name').must_equal('The Superstate of Eurasia')
    end
  end

end
