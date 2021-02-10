import 'package:flutter/material.dart';
import 'package:green_route/datamodels/address.dart';
import 'package:green_route/datamodels/prediction.dart';
import 'package:green_route/dataprovider/appdata.dart';
import 'package:green_route/helpers/requesthelper.dart';
import 'package:green_route/widgets/globalvariable.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:brand_colors/brand_colors.dart';
import 'package:provider/provider.dart';
import 'package:green_route/widgets/ProgessDialog.dart';

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  PredictionTile({this.prediction});

  void getPlaceDetails(String placeID, context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Please wait...',
      ),
    );

    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeID&key=$mapKey';

    var response = await RequestHelper.getRequest(url);
    Navigator.pop(context);

    if (response == 'failed') {
      return;
    }
    if (response['status'] == 'OK') {
      Address thisPlace = Address();
      thisPlace.placeName = response['result']['name'];
      thisPlace.placeId = placeID;
      thisPlace.latitude = response['result']['geometry']['location']['lat'];
      thisPlace.longitude = response['result']['geometry']['location']['lng'];

      Provider.of<AppData>(context, listen: false)
          .updateDestinationAddress(thisPlace);
      print(thisPlace.placeName);

      Navigator.pop(context, 'getDirection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        getPlaceDetails(prediction.placeId, context);
      },
      padding: EdgeInsets.all(0),
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Icon(
                  OMIcons.locationOn,
                  color: Colors.black,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prediction.mainText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Text(
                        prediction.secondaryText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 12.0, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    );
  }
}
