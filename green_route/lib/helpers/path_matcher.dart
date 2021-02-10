import 'dart:math';

int counter = 100;

bool preprocess(List start, List end, List user) {
  List start_new = [(pi / 180) * (start[0]), (pi / 180) * (start[1])];
  List end_new = [(pi / 180) * (end[0]), (pi / 180) * (end[1])];
  List user_new = [(pi / 180) * (user[0]), (pi / 180) * (user[1])];

  bool lat_check = pathMatching(start_new[0], end_new[0], user_new[0]);
  bool long_check = pathMatching(start_new[1], end_new[1], user_new[1]);

  if (lat_check & long_check) {
    return true;
  } else {
    return false;
  }
}

bool pathMatching(double start_coord, double end_coord, double user_coord) {
  print("Going In");
  double averageAngle = 0;

  double x = 0;
  double y = 0;

  for (double a in [start_coord, end_coord]) {
    x += cos(a);
    y += sin(a);
  }

  averageAngle = atan2(y, x);

  counter--;
  if (((absabs(user_coord, start_coord) <= 0.0001) &
      (absabs(user_coord, start_coord) <= 0.0001))) {
    counter = 100;
    return true;
  }

  if (counter == 0) {
    counter = 100;
    return false;
  }

  if ((user_coord) <= averageAngle) {
    return pathMatching(start_coord, averageAngle, user_coord);
  }
  return pathMatching(averageAngle, end_coord, user_coord);
}

double absabs(double c1, double c2) {
  if ((c1 - c2) < 0) {
    return (c2 - c1);
  }
  return (c1 - c2);
}
