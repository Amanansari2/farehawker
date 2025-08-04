import 'package:flightbooking/repository/policy_repo.dart';
import 'package:flutter/cupertino.dart';

class PolicyProvider extends ChangeNotifier{

  final PolicyRepository policyRepository = PolicyRepository();

  String? terms;
  String? privacy;
  String? refund;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadTermsCondition() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try{
      terms = await policyRepository.fetchTermsCondition();
    } catch(e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadPrivacyPolicy() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      privacy = await policyRepository.fetchPrivacyPolicy();
    } catch(e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadRefundPolicy() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try{
      refund = await policyRepository.fetchRefundPolicy();
    }catch(e){
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}