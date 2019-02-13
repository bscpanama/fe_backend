module Response
  def json_response(object, status = :ok)
    # render json: object, status: status, each_serializer: CustomerExchangeSerializer
    class_name = object.class.name
    response_object = if class_name == "Hash"
               object
             else
               serializer_class = class_name + "Serializer"
               serializer_class.constantize.new(object).serialized_json
             end
    render json: response_object, status: status
  end
end
