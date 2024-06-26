String validateEmailField(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty)
    return 'Email is Required.';
  else if (!regex.hasMatch(value)) return 'Invalid Email';
  else return '';
}

String validatePassword(String value) {
  // Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
  // RegExp regex = new RegExp(pattern);

  if (value.isEmpty)
    return 'Password is Required.';
  else if (value.length < 6)
    return 'Password required at least 6 numbers';
  // else if (!regex.hasMatch(value))
  //   return 'Password must contain numbers, letter, and at least six characters';
  else
    return '';
}

String validateNewPassword(String value) {
  // Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
  // RegExp regex = new RegExp(pattern);

  if (value.isEmpty)
    return 'New Password is Required.';
  else if (value.length < 6)
    return 'New Password required at least 6 numbers';
  // else if (!regex.hasMatch(value))
  //   return 'Password must contain numbers, letter, and at least six characters';
  else
    return '';
}

String validateName(String value) {
  if (value.isEmpty)
    return 'Name is Required.';
  else if (value.length < 3)
    return 'Name required at least 6 numbers';
  else
    return '';
}

String validateTitle(String value) {
  if (value.isEmpty)
    return 'Project Name is Required.';
  else
    return '';
}

String validatePromoCode(String value) {
  if (value.isEmpty)
    return 'Please enter promo code.';
  else
    return '';
}

String validateHome(String value) {
  if (value.isEmpty)
    return 'Home Name is Required.';
  else
    return '';
}

String validateBlock(String value) {
  if (value.isEmpty)
    return 'Block is Required.';
  else
    return '';
}

String validateStreet(String value) {
  if (value.isEmpty)
    return 'Street is Required.';
  else
    return '';
}

String validateAvenue(String value) {
  if (value.isEmpty)
    return 'Avenue is Required.';
  else
    return '';
}

String validateBuilding(String value) {
  if (value.isEmpty)
    return 'Building is Required.';
  else
    return '';
}

String validateAppartmentNo(String value) {
  if (value.isEmpty)
    return 'Appartment no. is Required.';
  else
    return '';
}

String validateOffice(String value) {
  if (value.isEmpty)
    return 'Office is Required.';
  else
    return '';
}

String validateFloor(String value) {
  if (value.isEmpty)
    return 'Floor is Required.';
  else
    return '';
}

String validateAreaName(String value) {
  if (value.isEmpty)
    return 'Area is Required.';
  else
    return '';
}

String validateAddressName(String value) {
  if (value.isEmpty)
    return 'Address Name is Required.';
  else if (value.length < 3)
    return 'Address Name required at least 6 numbers';
  else
    return '';
}

String validateMobile(String value) {
  if (value.isEmpty)
    return 'Mobile Number is Required.';
  else if (value.length < 8)
    return 'Mobile Number required 8 digits';
  else
    return '';
}
