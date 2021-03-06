# Defines the core upload and view TracksAPIs.
module Commuting
  class StoplightAPI < Grape::API
    version "v1", vendor: "g9labs"
    format :json

    helpers do
      params :pagination do
        optional :page, type: Integer
        optional :per_page, type: Integer
      end
    end

    namespace :commuting do
      resource :stoplights do
        desc "See all stoplight metrics"

        params do
          use :pagination
        end

        get do
          Commuting::StopEventCluster.page(params[:page]).per(params[:per_page])
        end
      end

      resource :geojson do
        desc "See all stoplights, in GeoJSON format"

        params do
          use :pagination
        end

        get do
          clusters = Commuting::StopEventCluster.query.page(params[:page]).per(params[:per_page])
          StoplightFeatureCollection.new(clusters).wrap
        end
      end

      resource :circle_geojson do
        desc "See all stoplight circle geometries, in GeoJSON format"

        params do
          use :pagination
        end

        get do
          clusters = Commuting::StopEventCluster.query.page(params[:page]).per(params[:per_page])
          StoplightFeatureCollection.new(clusters).wrap_circles
        end
      end
    end
  end
end
