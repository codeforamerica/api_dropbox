require 'sinatra'
require 'haml'
require 'json'
require 'couchrest'
require 'base64'




get "/" do
	haml :upload
end

post "/upload_file" do
	@db = CouchRest.database!("http://127.0.0.1:5984/boston_api")
	f = params[:upload][:file]
	@db.save_doc({"_attachments" => {
		f[:filename]=>{
			"content_type"=>f[:type],
			"data"=>f[:tempfile].read
		}
	}})
	"upload successful"
end