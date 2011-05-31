require 'sinatra'
require 'haml'
require 'json'
require 'couchrest'
require 'base64'


FIELDS=%w(title comments data_url organization department name email phone)

get "/" do
	haml :upload
end

post "/upload_file" do
	@db = CouchRest.database!("http://127.0.0.1:5984/boston_api")
	f = params[:upload][:file]

	doc = params[:upload].select {|k,v| FIELDS.include? k}
	doc["_attachments"]={
		f[:filename]=>{
			"content_type"=>f[:type],
			"data"=>f[:tempfile].read
		}
	}
	
	@db.save_doc(doc)
	"upload successful"
end