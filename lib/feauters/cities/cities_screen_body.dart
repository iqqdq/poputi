import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:poputi/ui/ui.dart';
import 'package:poputi/constants/constants.dart';
import 'package:poputi/api/models/models.dart';
import 'package:poputi/models/cities_view_model.dart';
import 'package:poputi/utils/utils.dart';
import 'package:provider/provider.dart';

class CitiesScreenBodyWidget extends StatefulWidget {
  final City? city;
  final Function(City) didReturnCity;

  const CitiesScreenBodyWidget({
    Key? key,
    this.city,
    required this.didReturnCity,
  }) : super(key: key);

  @override
  State<CitiesScreenBodyWidget> createState() => _CityScreenBodyState();
}

class _CityScreenBodyState extends State<CitiesScreenBodyWidget> {
  final _scrollController = ScrollController();
  final _pagination = Pagination(number: 1, size: 100);
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isRefresh = true;
  bool _isSearching = false;

  late CitiesViewModel _citiesViewModel;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _isRefresh = !_isRefresh;
          _pagination.number += 1;
        });
      }
    });

    _textEditingController.text = widget.city?.name ?? '';

    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    _textEditingController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _citiesViewModel = Provider.of<CitiesViewModel>(
      context,
      listen: true,
    );

    if (_isRefresh) {
      _isRefresh = !_isRefresh;
      _citiesViewModel.getCityList(
        _pagination,
        _textEditingController.text,
      );
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: HexColors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0.0,
          titleSpacing: 0.0,
          automaticallyImplyLeading: true,
          title: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child:

                /// SEARCH INPUT
                InputWidget(
              textEditingController: _textEditingController,
              focusNode: _focusNode,
              placeholder: Titles.search,
              isRequiredField: false,
              onChanged: (text) => {
                setState(() => _isSearching = true),
                EasyDebounce.debounce(
                    'city_debouncer', const Duration(milliseconds: 500),
                    () async {
                  _pagination.number = 1;
                  _citiesViewModel
                      .getCityList(
                        _pagination,
                        _textEditingController.text,
                      )
                      .then((value) => setState(() => _isSearching = false));
                })
              },
              onFieldSubmitted: () => FocusScope.of(context).unfocus(),
            ),
          ),
        ),
        body: InkWell(
            child: Stack(children: [
          SizedBox.expand(
              child: Container(
                  color: HexColors.white,
                  child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                          top: 8.0,
                          bottom: MediaQuery.of(context).padding.bottom == 0.0
                              ? 12.0
                              : MediaQuery.of(context).padding.bottom),
                      itemCount: _citiesViewModel.cities == null
                          ? 0
                          : _citiesViewModel.cities?.length,
                      itemBuilder: (context, index) {
                        return Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () => _citiesViewModel.selectCity(
                                    index,
                                    (city) => {
                                          widget.didReturnCity(city),
                                          Navigator.pop(context)
                                        }),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                          top: 20.0,
                                          left: 20.0,
                                          right: 20.0,
                                          bottom: 6.0,
                                        ),
                                        child: Text(
                                            _citiesViewModel
                                                    .cities?[index].name ??
                                                '',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: HexColors.dark,
                                            ))),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        top: 6.0,
                                        left: 20.0,
                                      ),
                                      height: 0.5,
                                      color: _citiesViewModel.cities == null
                                          ? Colors.transparent
                                          : index ==
                                                  _citiesViewModel
                                                          .cities!.length -
                                                      1
                                              ? Colors.transparent
                                              : HexColors.gray,
                                    )
                                  ],
                                )));
                      }))),

          /// EMPTY LIST TEXT
          _citiesViewModel.cities != null
              ? Container()
              : _citiesViewModel.loadingStatus == LoadingStatus.searching
                  ? Container()
                  : _citiesViewModel.loadingStatus != LoadingStatus.searching ||
                          _citiesViewModel.loadingStatus ==
                                  LoadingStatus.completed &&
                              _citiesViewModel.cities!.isEmpty
                      ? Center(
                          child: Padding(
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                bottom: 60.0,
                              ),
                              child: Text(Titles.no_results,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16.0,
                                    color: HexColors.gray,
                                  ))))
                      : Container(),

          /// INDICATOR
          _isSearching ||
                  _citiesViewModel.loadingStatus == LoadingStatus.searching
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 60.0),
                  child: Center(child: IndicatorWidget()))
              : Container(),
        ])));
  }
}
