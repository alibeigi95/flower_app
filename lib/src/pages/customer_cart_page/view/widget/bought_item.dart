import 'dart:convert';

import 'package:flower_app/src/pages/customer_home_page/models/bought_flowers_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../generated/locales.g.dart';
import '../../controller/customer_cart_page_controller.dart';
import 'delete_alert_dialog.dart';

class BoughtItem extends GetView<CustomerCartPageController> {
  final BoughtFlowersViewModel boughtFlower;

  const BoughtItem({
    required this.boughtFlower,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {},
            child: DecoratedBox(
              decoration: _imageFlower(),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.2, 1.0],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _name(),
                      const SizedBox(height: 8.0),
                      _description(),
                      const SizedBox(height: 8.0),
                      _vendorNameAndImage(),
                      const SizedBox(height: 5.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _color(),
                          _count(),
                          Row(
                            children: [
                              Obx(() =>
                                  _deleteCartBtn(boughtFlowers: boughtFlower)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _price(),
                          _buyCount(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );

  Widget _buyCount() {
    return Row(
      children: [
        Obx(() =>
            _editFlowerCountBuyCartMinusLoading(boughtFlowers: boughtFlower)),
        Text(
          "${LocaleKeys.customer_home_item_count_buy.tr} : ${boughtFlower.buyCount}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(
          () => _editFlowerCountBuyCartPlusLoading(boughtFlowers: boughtFlower),
        ),
      ],
    );
  }

  Widget _price() {
    return Row(children: [
      Text(
        LocaleKeys.customer_home_item_price.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        ('\$${controller.priceFormat(price: boughtFlower.flowerListViewModel.price.toString())}'),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }

  Widget _count() {
    return Row(children: [
      Text(
        LocaleKeys.customer_home_item_count.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        boughtFlower.flowerListViewModel.countInStock.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }

  Widget _color() {
    return Row(
      children: [
        Text(LocaleKeys.customer_home_item_color.tr,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        Container(
          decoration: BoxDecoration(
            color: Color(boughtFlower.flowerListViewModel.color),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
      ],
    );
  }

  Widget _vendorNameAndImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(LocaleKeys.customer_home_item_vendor_name.tr,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Text(boughtFlower.flowerListViewModel.vendorUser.firstName,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(width: 5.0),
            Text(boughtFlower.flowerListViewModel.vendorUser.lastName,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: boughtFlower.flowerListViewModel.vendorUser.image == ''
                      ? MemoryImage(base64Decode(
                          'iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAYAAAD0eNT6AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAN1wAADdcBQiibeAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAACAASURBVHic7N13mFXluTbwe0+DGYbFgoUwHYY+9N67dEQBEVQs2Gs8anIS076TfF9yckzTc1LUqInt2EUBFUGp0nvvMMN0kAWLRRmm7u+PvVXKlD2zy7PK/bsuL0jC7H0nYea597vWel+P1+sFEVmbbpjxALQ6/mkCoBGAOP+vgfweAEoBlPl/DeT3FwDotf2jqUpJOP53IKLQ8bAAEMnRDTMOQDqATABtL/s1CVcO93iZhA1WgitLQTGAHADZl/2ap6lKmVA+ItdjASAKI90wowBk4MrhfvmvKQCiZNKJqwJQiCtLweW/5mqqUiWUjcjxWACIQkQ3zJYAegLo4f+1J4BusN+nd6soAbAXwC7/P7sB7NJU5ZRoKiKHYAEgqif/sn0Wvh/y3w78ZMlcLlKEywqB/5/9vJxAVD8sAER10A2zPYBhAIYDGAKgC4AY0VB0tQoABwCsB7AGwFpNVY7KRiKyNhYAosvohhkDoA++H/jD4Lshj+ynGMBa+AsBgO2aqlTIRiKyDhYAcjXdMBX4PtV/O/AHAUgQDUXhchHARnxfCNZrqmLKRiKSwwJAruK/K38ggMkAJgHoD/fehe92VQC2APgCwGIAm/jUAbkJCwA5nm6YSQAmwjfwJwBoIZuILOo0gKXwFYIlmqoUC+chCisWAHIc/3X8ofAN/EkAegPwiIYiu/EC2AFfGfgCwDreP0BOwwJAjqAbZjMA0wHcCGAcAEU2ETmMCeArAAsBfKKpylnhPERBYwEg29INsyl8A38OfEv8cbKJyCXKACwB8B6AhZqqnBPOQ9QgLABkK7phNgFwA3xDfzKAxrKJyOUuwXcD4XsAPtVU5YJwHqKAsQCQ5flPwpsC39CfCj6mR9Z0EcBn8JWBz3kiIlkdCwBZkv9xvQkA7gIwDUCibCKiejkPYBGANwAs5eOFZEUsAGQpumGmAbgXwH3wnaJHZHe5AF4F8E9NVfKlwxB9iwWAxOmGGQ3f0v4D8F3Xj5ZNRBQWlfDdL/AygM80VakUzkMuxwJAYnTDzITvk/49AFKE4xBFUiGAfwF4VVOVbOkw5E4sABRRumHGArgJwIPwPa/PDXrIzbzw7S/wDwALNFUpF85DLsICQBGhG2ZLAI8CeAxAK+E4RFZ0EsDfAPxdU5VT0mHI+VgAKKx0w+wI4GkAdwOIF45DZAclAF4H8GdNVQ5LhyHnYgGgsNANcziAH8K3Ux9P2yOqvyr4th7+k6Yqa6TDkPOwAFDI+O/mnwHgRwAGCcchcpKNAP4I4GM+PUChwgJAQfNvz3svgCcBtBOOQ+Rk2QCeg29PAW47TEFhAaAG0w1TgW/oPwmguXAcIjc5A+B5AM9rqmJKhyF7YgGgevN/4n8cwI8BtBCOQ+RmpwH8HsBfuSJA9cUCQAHTDbMxgEcAPAM+ykdkJScB/BeAFzRVuSQdhuyBBYDqpBtmHID7Afwc3LGPyMoKAfwWwCuaqpRJhyFrYwGgGumGGQNgHoBfggfzENlJLoD/B+A1TVUqpMOQNbEA0DX8R/HOBfAfANoLxyGihjsK4NcA/pdHEtPVWADoCrphjobv7uJewlGIKHR2AnhSU5WV0kHIOlgACMB3J/P9EcBM6SxEFDbzAfyIJxASwALgerphJgL4GXz79TcSjkNE4VcK4M8A/lNTlfPSYUgOC4BL6Ybpge+Ant8BSBKOQ0SRVwzgpwBe11SFg8CFWABcSDfMYfBd5+8vnYWIxG2B7/6AtdJBKLJYAFxEN8wMAM8CuFU6CxFZzrsAfqKpSq50EIoMFgAX8J/S9xR8jwMlCMchIuu6CN/jv8/x1EHnYwFwON0wewN4BUA/6SxEZBtbAdyvqcoO6SAUPiwADuXft/9XAH4IIEY2DRHZUAWAPwH4Fc8XcCYWAAfyb+bzDwAdhaMQkf0dBvAgNxFyHhYAB9ENUwXwBwD3AfAIxyEi5/ACeBXAv2uqYkiHodBgAXAI3TBnAvgrgGTpLETkWEUAHtdUZb50EAoeC4DN6YaZBODvAGZIZyEi1/gYwKOaqhRLB6GGYwGwMd0wb4RvWa6ldBYicp1TAO7TVGWhdBBqGBYAG9INMwG+vbwfks5CRK73EoCnNVW5KB2E6ocFwGZ0w+wL4G0AnaWzEBH5HQRwu6Yq26SDUOBYAGxCN8woAD8C8BsAscJxiIiuVg7gFwD+qKlKlXQYqhsLgA3ohpkG4A0AY6SzEBHVYQWAuzRVyZcOQrWLkg5AtdMN8xYAu8DhT0T2MAbALv/PLrIwrgBYlG6YiQD+AmCecBQiooZ6DcAPNFU5Lx2ErsUCYEG6YXaG7znbLOksRERB2g9ghqYqB6WD0JV4CcBidMOcDmATOPyJyBmyAGzy/2wjC+EKgEX47/L/DYBnwH38ich5vAD+C8Av+JSANbAAWIBumBp8z/ZPkM5CRBRmS+HbM0CXDuJ2LADC/Bv7zAfQRjoLEVGEHAcwkxsHyeI9AIJ0w5wHYC04/InIXdoAWOv/GUhCuAIgQDfMOADPA3hEOgsRkbAXADypqUqZdBC3YQGIMN0wW8P3iN8Q6SxERBaxHr5HBU9IB3ETFoAI0g0zC8DnANoKRyEispocAFM0VdkvHcQteA9AhOiGOQbAOnD4ExFVpy2Adf6flRQBLAARoBvmXQCWAFClsxARWZgKYIn/ZyaFGQtAmOmG+SsAr4NH+BIRBSIWwOv+n50URrwHIEz8d/q/AuBO6SxERDb1JoD7+YRAeLAAhIFumCp8d/qPFo5CLuP1enHmrImik9/gG/00zHPnce7CBZw77//H/3vz/AWUlpWhSUI8EhMS0LRJEyQmJiAxIQGJTZqgaZMEJDbx/T7R//um/t/HxXIxiyJqJXxPCBjSQZyGBSDEdMPMBPAZeJgPhVHJpUvILShC0clvUHzyGxSdPIXib77BiW90lJaF98NSXGwskltdh8yMNLRNT/X9k5aKRnFxYX1fcrX9AKZqqpItHcRJWABCSDfMfvA95tdKOgs5R1VVFfKLTuBIznEczj6OIzm5KCg+ASt973o8nu9KQWZ6Ktqm+35NiI+XjkbOcRK+xwS3SgdxChaAENENczh8n/wV6Sxkb6VlZdh/+Cj2HzmGw9nHcex4Xtg/1YdLq5YaMtNTkZmehvZtM5DVoR2io6OlY5F9mfCtBKyRDuIELAAhoBvmeACfAEiQzkL2VFB8Ajv2HsDOfQdw4MgxlFdUSEcKiyYJ8RjQqwcG9emJ7p07ISaGZYDq7SKA6ZqqfCkdxO5YAIKkG+ZNAN4D0Eg6C9lHyaVS7Dl4CDv3HcDOfQdx6vQZ6UgRlxAfj/49u2FQ317o0aUTYmNipCORfZQCmKOpygLpIHbGAhAE3TBvA/AGAP7kojqVl1dg+959WLt5G7bv2e/YT/kNEd+4Mfr17IZBfXqiV1YXxMbyW4rqVAHgLk1V3pEOYlcsAA2kG+b9AF4CN1OiWlRVVWHvoSNYt2U7Nu3YhYsll6QjWV5840bo070rBvfthV5du/CxQ6pNFYCHNFV5RTqIHbEANIBumE8C+DMAj3QWsqajx/OwdvNWrN+6A4Z5TjqObSXEN8b4kcMwZcxIKE0TpeOQNXkBPK2pyvPSQeyGBaCedMP8BYD/J52DrKe8vALrtm7HklVrkJ2bLx3HUeJiYzF66EBMGzcGLVs0l45D1vRLTVV+Ix3CTlgA6kE3zGcB/Fg6B1nLqdNn8NXX67B83UacO39BOo6jRUdFYdiAvpg2fizSkltLxyHr+b2mKj+RDmEXLAAB4vCnq+09dARLVq7B1t17UVVVJR3HVTweD/r17IbpE65H+7YZ0nHIWlgCAsQCEAAu+9O3vF4v1m7ZjgVLliG/qFg6DgHo1rkDbppwPXp06SQdhayDlwMCwAJQB/8Nf89J5yBZXq8X67fuwEefL0XhiZPScaga7duk46aJ16N/z+7weHh/LuEp3hhYOxaAWvgf9fsHeLe/a3m9XmzYthPzFy9FftEJ6TgUgOu0Fujboyv6du+KrI7tucGQe3kBPMhHBGvGAlAD/yY/b4HP+buS1+vFxu278NHnS7nUb2ONGzVC9y4d0a1TB7RJTUFGagqaJPCAIhepAnAHNwuqHgtANfzb+34I7vDnSrsPHMKbHy1EXmGRdBQKA625ijapKWiT5isEbdNS0fo6jZcNnKsCwCxuG3wtFoCr+A/2WQTu7e86J/XTePOjBdiyc490FIqwRnFxyPCXgrZpKWiTlor0lCQ0iouTjkahUQpgGg8QuhILwGX8R/ouAU/1c5XSsjIsWLIcny5bgfJy7s9PPh6PB+0y0tAzqwt6ZnVCx8w2PMrY3i4CmMijhL/HAuCnG2Y/AMsBKNJZKHI2bNuBt+Yvgn7GkI5CFhffuBG6duqAnl06o2dWZyS1aikdierPBDBWU5Wt0kGsgAUAgG6YmQA2AGglnYUiI6+wCP96/2PsP3xUOgrZVKuWGiaMHIqxw4YgvjGvGNrISQCDNVXJlg4izfUFQDdMFcA6AFnSWSj8Kquq8MkXX+HjxV+ikrv3UQgkxMdj/MihmDxmBJo1bSodhwKzH8BQTVVcvfTn6gKgG2YcfNf8RwtHoQjILyrG319/B9l5PKiHQi82JgYjB/fHDdeP4eUBe1gJ3z0BZdJBpLi9ALwB4E7pHBReXq8Xn361Eh98+gXKK3iTH4WXx+PBgF49MGvqBKSnJEvHodq9qanKXdIhpLi2AOiG+SsA/yGdg8Kr+OQpvPDmOzh0LEc6CrlMTEw0Zk2dhBvHj+EeA9b2a01VfiUdQoIrC4BumHcBeF06B4WP1+vF0tVr8c4nn6G0zLUrfGQBndtl4pG7b0Prlpp0FKrZ3ZqqvCEdItJcVwB0wxwD33X/WOksFB4XSy7hb6+/jW2790pHIQLge4Tw6QfvQffOHaWjUPXK4bsfYIV0kEhyVQHQDTMLvjv+VeksFB75RcX40z/+heKTp6SjEF0hNiYGP7j3Dgzo1UM6ClXPgO/JgP3SQSLFNQVAN8zW8D3r31Y4CoXJhm078OKb73HJnywrKioKD86djVGDB0hHoerlwLdHgCuO/nRFAfA/7rcSwBDhKBQGVVVVeGfBZ/j0q5XSUYjq5PF48Pi8uRjav490FKreegCj3fB4oFuOun0eHP6OZJ4/j//860sc/mQbXq8XL771Lg5nH5eOQtUbAt/McDzHrwDohjkPwL+kc1Do5eQV4I8v/ZP7+JMtNWvaFL/58b+hZYvm0lGoevdoqvKadIhwcnQB0A2zL4C1ABpLZ6HQ2nvoCP700j9RcqlUOgpRg6WnJOPXP/wBzxKwpksAhmmqsk06SLg49hKAbpgagPng8HecLTv34Nm/vczhT7aXV1iEv/zrTTj5g5iNNQYw3z9LHMmRBUA3zCgAbwNoI52FQmvl+k147pXXuaUvOcb2Pfvx+fJV0jGoem0AvO2fKY7jyP9SAH4DYIJ0CAqtRV+uwEtvvYcqnuJHDvPeosUoPHFSOgZVbwJ8M8VxHFcAdMOcDuAZ6RwUWm9//Cne/uRT6RhEYVFeXoEX33yX5da6nvHPFkdxVAHQDbMzfHv88+QNh/B6vXjprfew6CtX7dBJLnQ4+zg+W8ZLARblAfC6f8Y4hmMKgG6YiQA+BqBIZ6HQeeWdD7Fy/SbpGEQR8cGnX6Cg2BWb0NmRAuBj/6xxBMcUAAB/AZAlHYJC5+1PPsXytRukYxBFTHlFBd6av1A6BtUsC75Z4wiOKAC6Yd4CYJ50DgqdhUuXY9GXXPYn99mx9wAOHcuRjkE1m+efObZn+wKgG2YagJekc1DoLFuzAe8s+Ew6BpGY9z9dLB2BaveSf/bYmq0LgP/ZzDcAcC9Nh9iwbQdeffdD6RhEovYePIK9h45Ix6CaNQfwht33B7B1eAA/AjBGOgSFxq79B/HX197mrmhEAD5Y9IV0BKrdGPhmkG3ZtgD49/l35OYMbnQ0Jxd//sdrqKyslI5CZAkHj2Vj3+Gj0jGodr/xzyJbsmUB0A0zAb6tfmOls1DwzHPn8eeXX0NpmeOP3yaqFz4FY3mx8G0VnCAdpCFsWQAA/BmAozZkcKvKqio8/+obOG2clY5CZDmbduzCxZIS6RhUu87wzSTbsV0B0A3zRgAPSeeg0Pjf+Yuwn8ucRNUqL6/Amk2OPY3WSR7yzyZbsVUB0A0zCcCr0jkoNNZu3obFK1ZLxyCytBXrN0pHoMC86p9RtmGrAgDg7wBaSoeg4B0vKMTLb38gHYPI8nLyCnA8v0A6BtWtJXwzyjZsUwB0w5wJYIZ0DgrehYsl+PM/eNMfUaDWbt4uHYECM8M/q2zBFgVAN0wVwF+lc1DwvF4v/vKvt3DylC4dhcg2dh88JB2BAvdX/8yyPFsUAAB/AJAsHYKCt2zNeuzcd0A6BpGtHM8vxLnzF6RjUGCS4ZtZlmf5AqAb5mgA90nnoODpZwy8/cmn0jGIbMfr9WLvocPSMShw9/lnl6VZugDohtkYwD8AeKSzUPBefvsDlFwqlY5BZEt7DrIA2IgHwD/8M8yyLF0AAPwKQEfpEBS8VRs2c+mfKAi7D7AA2ExH+GaYZVm2AOiG2RvAD6VzUPCMsybe/GiBdAwiWzt5Ssc3+mnpGFQ/P/TPMkuyZAHQDTMawCsAYqSzUPBefe8jXLjI7UyJgpWdly8dgeonBsAr/plmOZYsAACeAtBPOgQFb/3WHdiyc490DCJHyC0oko5A9dcPvplmOZYrALphZgD4tXQOCt7Fkkt47f2PpWMQOQYLgG392j/bLMVyBQDAswBsebQiXWnRl8thnj8vHYPIMfIKWQBsKgG+2WYplioAumEOA3CrdA4KnmGew+IVX0vHIHKUE6d0bqFtX7f6Z5xlWKYA6IbpAfC8dA4KjfmLv+QPKqIQ83q9yC8slo5BDfe8f9ZZgmUKAIC7AfSXDkHBO3FKx/K1G6RjEDlSLi8D2Fl/+GadJViiAOiGmQjgd9I5KDTeX7QYlZWV0jGIHOnU6TPSESg4v/PPPHGWKAAAfgYgSToEBe94fgHWb90hHYPIsc5fvCgdgYKTBN/MEydeAHTDzATwtHQOCo13F34Or9crHYPIsc6fZwFwgKf9s0+UeAEA8EcAjaRDUPAOHDmGHXu53z9ROHEFwBEawTf7RIkWAP9xiTMlM1DoLF6xWjoCkeOdv8AC4BAzpY8MFisAumFGgY/9OYZ+xsCWXXulYxA53vkLF6QjUOg875+FIiRXAOYC6CX4/hRCy9asR1VVlXQMIsfjJQBH6QXfLBQhUgB0w4wB8B8S702hV1FRiWV87p8oIkoulbJsO8t/+GdixEmtAMwD0F7ovSnENmzfCfMc9/wnigSv18tVAGdpD99MjLiIFwDdMOMA/DLS70vhs3TVWukIRK7CGwEd55f+2RhREisA9wOw3LGI1DDZefk4nJ0jHYPIVS5wBcBpMuCbjREV0QKgG2ZjAD+P5HtSePHTP1HkneMKgBP93D8jIybSKwCPAEiJ8HtSmJSWlWHdlu3SMYhch5cAHCkFvhkZMRErALphNgHwTKTej8Jv9/5DKCsvl45B5Dq8BOBYz/hnZUREcgXgcQCtIvh+FGbb9uyTjkDkSud4HoBTtYJvVkZERAqAbpgKgB9H4r0oMrxeL7azABCJ4GOAjvZj/8wMu0itADwJoEWE3osiIDsvH4Z5TjoGkStxO2BHawHfzAy7sBcA//WMiPyXocjZtpuf/omknPhGl45A4fVkJO4FiMQKwL0AmkfgfSiC9hw4LB2ByLXyCotQye2Anaw5fLMzrMJaAHTDjAbwVDjfgyLP6/UiJ79AOgaRa5VXVKCg6IR0DAqvp/wzNGzCvQIwA0BmmN+DIqz4m1MoLSuTjkHkajl5+dIRKLwy4ZuhYRPuAvCjML8+CcjJ46d/ImnZ/D50g7DO0LAVAN0whwMYFK7XJznHufxPJI6X4VxhkH+WhkU4VwB+GMbXJkH85EEk73h+Abxer3QMCr+wzdKwFADdMDsCuDEcr03yjucXSkcgcr2SS6V8HNAdbvTP1JAL1wrA02F8bRJUXl6Bs+e4ARCRFeTk80ZAF4iCb6aG5YVDSjfMlgDuDvXrkjUYpikdgYj8eDnONe72z9aQCsen9EcBxIfhdckCuP0vkXXwiRzXiIdvtoZUSAuAbpixAB4L5WuStZxlASCyDBYAV3nMP2NDJtQrADeBR/46Gi8BEFmHef48ThtnpWNQZLSCb8aGTKgLwIMhfj2yGF4CILIW7gjoKiGdsSErALphZgIYF6rXI2tiASCyFt4I6Crj/LM2JEK5AnAfAE8IX48siJcAiKyl+OQ30hEocjzwzdqQCEkB8J9YdE8oXousjSsARNZy5ixLucvcE6pTAkO1AjAVQEqIXossjE8BEFkLC4DrpMA3c4MWqgLwQIhehyyOBYDIWlgAXCkkMzfoAqAbZhqAySHIQhZ34WIJyisqpGMQ0WVKLl1CaVmZdAyKrMn+2RuUUKwA3AsgJNcjyNp4AyCRNXEVwHWi4Zu9QQmqAOiGGYUQ3pFI1sYbAImsiQXAle7zz+AGC3YFYAKAjCBfg2zi3Pnz0hGIqBoGC4AbZcA3gxss2AJwV5BfTzZSUVEpHYGIqsEVANcKagY3uADohhkPYFowb072UlHJAkBkRVwBcK1p/lncIMGsAEwBkBjE15PNVFZWSUcgomqcOcsDgVwqEb5Z3CDBFIA5QXwt2VBVFVcAiKzoDJ/QcbMGz+IGFQDdMJsgRDsRkX1UcAWAyJLOGCwALjbVP5PrraErADcASGjg15JNVfIeACJL4h4drpYA30yut4YWAC7/u1BlFVcAiKzoYgl3A3S5Bs3kehcA3TCbglv/uhJXAIisi48Cutpk/2yul4asANwIoHEDvo5sjgWAyLp4UJerNYZvNtdLQwoAl/9dipcAiKyr5NIl6Qgkq96zuV4FQDfMZgAm1vdNyBm4AkBkXZdKeQ+Ay030z+iA1XcFYDqAuHp+DTkENwIisq5LpaXSEUhWHHwzOmD1LQD1vsZAzlHJjYCILItPARDqOaMDLgC6YcYAGFfvOOQYvARAZF2lvARAwDj/rA5IfVYAhgJQ6p+HnIKXAIisi/cAEHwzemigf7g+BWBS/bMQEVEklJbxHgACUI9ZzQJAAYuOjpaOQEQ14D0A5BfaAqAbZhKA3g2OQ44QwwJAZFm8BEB+vf0zu06BrgBMBOBpeB5ygqioYE6PJqJw4k2A5OdBgPv1BPoTncv/xBUAIgvjJQC6TEAzu84CoBtmFIAJQcch24uO5goAkVVxIyC6zAT/7K5VID/RBwJoEXwesjveBEhkXbwHgC7TAr7ZXatACgCP/iUAXAEgsjJeAqCr1Dm7A/mJzuv/BACIjuIKAJFV8RIAXaXO2V1rAdANUwHQP2RxyNZ4CYDIuvgUAF2lv3+G16iuFYAhAfwZcgk+BUBkXWXl5dIRyFqi4Jvhtf6B2gwLXRayO94DQGRdXq8XXq9XOgZZS60zvK6f6MNDGIRsjpcAiKytigWArlTrDK+xAPiPFBwU8jhkW9HcCZDI0qqqeGInXWFQbccD1/YTvQ+AhNDnIbviCgCRtfESAF0lAb5ZXq3aCgCv/9MV+MOFyNq4AkDVqHGW11YAeP2frlBaxruMiayMJZ2qUeMs5woABYyPGRFZW1UVCwBdo34rALphtgcQ0HnC5B5l3GqUyNK8Xl4CoGsk+Wf6NWpaAeCnf7oGLwEQWRtXAKgG1c70mgoAr//TNcrKuQJAZGXcB4BqUO1Mr6kA1Lp9ILlTGVcAiCyNTwFQDaqd6dcUAN0w4wB0CXscsp1S3gRIZGl8CoBq0MU/269Q3QpAFoAadw4i9+JNgETWxhUAqkEMfLP9CtUVgJ7hz0J2xEsARNbGFQCqxTWznQWAAlbKmwCJLI1PAVAtAioAPSIQhGzo3PkL0hGIqBaXSkulI5B1XTPbuQJAAcnOzUduQZF0DCKqxbK1G6QjkHXVvgKgG2ZLAMkRi0O28emyldIRiKgOq9ZvwpmzpnQMsqZk/4z/ztUrAPz0T9fQzxjYuG2ndAwiqkN5RQU+Y1mnml0x468uALz+T9f4YuXXqOTjRUS28NXX63m/DtXkihnPFQCqVcmlUizndUUi2ygtK8PiFaulY5A11boCwAJAV1i5fiMullySjkFE9bBk1Rp+31J1qi8AumFGAegW8ThkaSvXb5KOQET1dLHkEtZs2iodg6ynm3/WA7hyBSADQHzk85BVGeY5PvpHZFM79u2XjkDWEw/frAdwZQFoG/EoZGl7DhySjkBEDbTv0FGUV1RIxyDrafvtby4vAJmRz0FWtmv/QekIRNRApWVlOHDkmHQMsp7vZj1XAKhGu7kCQGRrO/byMgBdo+23v+EKAFUrr7AIhnlOOgYRBWHnPq7i0TW4AkC127Wfn/6J7K6g+AROnT4jHYOspe23v+EKAFWL1/+JnGHnvgPSEcharlwB0A0zDkCKWByynCM5x6UjEFEI8EZAukqKf+Z/twKQjuqPBiYXulhyibuIETnENzovAdAVouCb+d8NfS7/03f0M/yBQeQUp/j9TNfKBL4vAG3lcpDVnDptSEcgohA5c9bkaZ50tbYAVwCoGvzEQOQcVVVVOGOclY5B1sIVAKrehYsl0hGIKITOX7goHYGspS3wfQFIkstBVlNZWSkdgYhCiN/TdJUk4PsCoAkGIYuprOT1QiIn4T0AdBUNYAGgalRV8dMCkZNwBYCuwgJA1avgCgCRo3AFgK7iKwC6YcYDiBcOQxbi8UgnIKJQ8nq90hHIWuJ1w4yPAj/901USExKkIxBRCCU24fc0XUNjAaBrNE1sIh2BiEKoaRN+T9M1WADoWiwARM7C72mqBgsAXSuRnxaIHCM2NgaN4uKkY5D1sADQtbhcSOQc/H6mGrAA0LVUJVE6AhGFSLOmkPYoCQAAIABJREFUTaUjkDWxANC1Eps04TVDIodIbn2ddASyJhYAql5aUmvpCEQUAmnJ/F6mamlRAPhRj66RmszzoYicIDWJ38tUrSZRABpJpyDr4QoAkTNwBYBq0CgKAJ8PoWuk8ocGke1FR0ej9XUtpWOQNcVxBYCqlcoVACLbS251HaKjour+g+RGjVgAqFrNmylQmvJxQCI7a5OWIh2BrIuXAKhm3Tt3lI5AREHg9zDVgpcAqGY9unSSjkBEQeD3MNWClwCoZvzhQWRfKa1bQWuuSscg6+IlAKqZ1lxFSutW0jGIqAFY4KkOvARAteMPESJ74vcu1YGXAKh2/CFCZD/RUVHo2qmDdAyyNl4CoNp17dSezxET2UyHzDaIb8zPdlQrXgKg2sU3boze3bOkYxBRPQzp11s6AllfI360ozqNGTJIOgIRBSguNhYjBvaTjkE2EAWgVDoEWVvv7llQmynSMYgoAIP79kJCfLx0DLK+0igAZdIpyNqio6IwalB/6RhEFICxwwZLRyB7KOMKAAVk9FBeBiCyupTWrdC5faZ0DLKHUhYACkjSdS2R1bG9dAwiqgU//VM98BIABW4sVwGILCsmJhojeamOAsdLABS4QX17cW9xIosaOWgAmiY2kY5B9sFLABS42JgYzJw8XjoGEV0lJiYaMyaNk45B9sJLAFQ/o4YMROuWmnQMIrrM2GGD0bJFc+kYZC+8BED1Ex0VhZunTpSOQUR+sbExmD6Rn/6p3ngJgOpv+IC+SE1qLR2DiACMHzEUzblRF9UfLwFQ/Xk8HsziKgCRuEZxcbhpwvXSMcieeAmAGmZQn55ok5YqHYPI1SaOHg6laaJ0DLKn0igAF6RTkP14PB7cM2cGPB6PdBQiV2qhNuO1fwrGhSgAunQKsqfO7TK58xiRkHvmzER8Y57mTg2mswBQUG6fPhWq0lQ6BpGrDOzdA/17dpeOQfbGAkDBSYiPx12zpkvHIHKN+MaNMW/2TOkYZH8sABS8If16o3e3LtIxiFzhtpum8LE/CgUWAAqNe+fcjEZxcdIxiBytY2YbjBsxVDoGOQMLAIXGdVoLzJ1xg3QMIsdq3KgRHr7zVj55Q6HCAkChM37kMAwf2E86BpEjPXTHHKS0biUdg5yDBYBC6/7bZiEjNVk6BpGjTL1+NAb37SUdg5xFj9JUpQRAiXQScoZGcXF4+sF7kBAfLx2FyBG6dmyP26ZPlY5BzlKiqUpJlP9fcBWAQqZ1Sw2Pzbud1yqJgtRCbYZ/u+8uREdF1f2HiQKnAwALAIVF3+5dMXPyeOkYRLYVExONJ++/m3v9UziwAFB43TxlAnp15f4ARA1x16zp6JjZRjoGOdMVBaBYMAg5lMfjwePz5qKV1kI6CpGtjBzUH+P5vD+FTzHwfQHIkctBTpbYJAFPPTAPsbEx0lGIbKFNWiruu22WdAxythzg+wKQLZeDnK5teiruu5U/0Ijq0iQhHk8/OA9xsbHSUcjZsgGuAFCEjBo8gFuYEtXCd8nsDl4yo0jIAbgCQBF096zp6NA2QzoGkSXdPGUCD9WiSLliBSAPQJVcFnKDmJhoPPXAPGjNVekoRJYypF9vPjZLkVIF38z3FQBNVcoAFEomIndooTbDz594GM2aNpWOQmQJvbtl4bG7uXEWRUyhf+bj8u2leBmAIiK51XX42Q8eQpMEbhdM7pbVsT2eeuBuREdHS0ch9/hu1l9eAHIin4PcKiM1Gc889iAaN2okHYVIRLuMdPz7w/fxjn+KtJxvf8MVABLToW0G/v2R+7hHALlOWnISfvr4A4hvzAJMEccVALKGrh3b46n753EJlFyjVUsNP/vBQ0hs0kQ6CrlTzre/4QoAievTPQuP8/RAcoHmzRT8/ImH0byZIh2F3IsrAGQtg/v2xoNzZ7MEkGM1TWyCnz/xMDf6IWk53/7m8gKQC6Ak4lGI/EYPGYi7Zt0kHYMo5OIbN8ZPH3sQqUmtpaOQu5XAN+sBXFYANFWpArBXIhHRtyaNHoHZ0yZLxyAKmbjYWPz4kfuQmZEmHYVor3/WA7hyBQAAdkU4DNE1Zkwah2njx0jHIApadLRv98suHdpJRyECrprxLABkSbdPvwFjhg6SjkEUlAfnzub+/mQltRaA3REMQlSre2bPRHpKsnQMogYZMbAfRg7qLx2D6HJXzHiuAJBlxcbG4Il77+BGQWQ7rVtquGfOzdIxiK5W8wqApiqnABRFNA5RLdKSkzB3xjTpGEQB83g8+ME9d3CXP7KaIv+M/87VKwAAVwHIYiaMHIbMdN5BTfYwdtggtG+bIR2D6GrXzPbqCgDvAyBL8Xg8uPuW6dIxiOqUEB/Px1jJqq6Z7VwBIFvo3D4TQ/r1lo5BVKtZUydASUyUjkFUnYBWAFgAyJLmzpjGo1PJslKTWmPCqOHSMYhqElAB2A+gIvxZiOpHa65ygyCyrDtvvhHRUdX9SCUSVwHfbL/CNX9bNVUpA3AgEomI6uuGcaO5xEqW07Vje/Tqyg1/yLIO+Gf7FWqqq+vDHIaoQRo3aoTpk8ZJxyC6wq03TZGOQFSbamd6TQVgTRiDEAVl3IghaNmiuXQMIgBAn+5Z6JjZVjoGUW2qnek1FYC1YQxCFJTYmBjcPGWCdAwieDwezOFjf2R91c70aguApipHARSHNQ5REEYO6o+U1q2kY5DLDe7bC23SUqVjENWm2D/Tr1HbLatcBSDLioqKwpwb+cmL5ERFRWHW1InSMYjqUuMsr60A8D4AsrSBvXuiXUa6dAxyKa5CkU3UOMu5AkC2xruvSUJMTDTvQyG7aNAKwHYAF0OfhSh0enTphG6dOkjHIJe5fjifRCFbuAjfLK9WjQVAU5UKABvDkYgolObcyFUAipxGcXGYwb0oyB42+md5terat5L3AZDldcxsg/49u0vHIJeYNHo4mjVtKh2DKBC1zvC6CgDvAyBbmD1tMjwej3QMcriE+MaYNn6sdAyiQNU6w+sqAOsBVIUuC1F4pKckYdiAvtIxyOFuGDcaTRLipWMQBaIKdWzrX2sB0FTFBLAllImIwuWWqRMRHR0tHYMcqmliE0weM1I6BlGgtvhneI0CObvyixCFIQqrVi01jB06SDoGOdRNE65H40aNpGMQBarO2R1IAVgcgiBEETFz8njExcZKxyCHad5MwYSRw6RjENVHnbM7kAKwCcDp4LMQhZ/aTMGkMSOkY5DDzJw8HrGxMdIxiAJ1Gr7ZXas6C4CmKlUAloYiEVEkTBs3BgnxjaVjkEO00lpgDC8tkb0s9c/uWgWyAgDwPgCykcQmCbhh3BjpGOQQN/PmUrKfgGZ2oAVgCQBvw7MQRdaUsSOhNE2UjkE2l5rUGiMG9pOOQVQfXvhmdp0CKgCaqhQD2BFMIqJI4natFAq33DCJG0yR3ezwz+w6BboCAPAyANnMuOFDeWALNVjb9FQM7N1DOgZRfQU8q1kAyLF4ZCsFYw63lyZ7CksBWAeg1l2FiKxm5KD+SGndSjoG2Uzndpno3S1LOgZRfZnwzeqABFwA/EcKftWQRERSoqKiMG/2DOkYZCMejwd3z54uHYOoIb6q7fjfq9VnBQAAFtbzzxOJ69GlE4b26yMdg2xiwshhyExPk45B1BD1mtH1LQCfACir59cQibtz1k3cHIjqpCpNMXvaZOkYRA1RBt+MDli9CoCmKmcR4POFRFaiKk0xZ9oU6RhkcXfMvJFFkexqiX9GB6y+KwAA8F4DvoZI3PiRQ9G+Tbp0DLKobp07YNiAvtIxiBqq3rO5IQVgIYBLDfg6IlEejwf33TYLUVEN+WtPThYTE41759wsHYOooS6hAffo1fsnoaYq58AjgsmmMtPTMHEUj3WlK91w/Wg+Lkp2ttg/m+uloR+FeBmAbOuWGyajeTNFOgZZxHVaC8yYPF46BlEwGjSTG1oAPgVwsYFfSyQqvnEj3H0L9wYgn3mzZyAuNlY6BlFDXYRvJtdbgwqApioXAHzWkK8lsoJBfXqid7cu0jFIWP9e3dG3e1fpGETB+Mw/k+stmLuheBmAbO2e2TOlI5Cwu2dxxz+yvQbP4mAKwOcAzgfx9USiWrXUpCOQMJ4WSTZ3Hr5Z3CANLgCaqpQAWNTQryciIqKgLPLP4gYJ9oHoN4L8eiIiImqYoGZwsAVgKYDcIF+DiIiI6icXvhncYEEVAE1VqgC8GsxrEBERUb296p/BDRaKPVH/CaAyBK9DREREdauEb/YGJegCoKlKPrg1MBERUaQs9s/eoITqVJSXQ/Q6REREVLuQzNxQFYDPABSG6LWIiIioeoUI0U68ISkAmqpUAvhXKF6LiIiIavQv/8wNWigPRn8VgDeEr0dERETf8yKET96FrABoqpIN4KtQvR4RERFd4Sv/rA2JUK4AAMA/Qvx6RERE5BPSGRvqArAAwMkQvyYREZHbnYRvxoZMSAuApirlAP4WytckIiIi/M0/Y0Mm1CsAAPB3AA0+nYgoUrxe3rPqdvw7QDZRAt9sDamQFwBNVU4BeD3Ur0sUaqdOn5GOQMK+0U9LRyAKxOv+2RpS4VgBAIA/AwjqkAKicMsrKpaOQMLy+XeArK8KvpkacmEpAJqqHAawMByvTRQqeYX84e92/DtANrDQP1NDLlwrAADwpzC+NlHQ8guLpCOQMK4AkA2EbZaGrQBoqrIGwMZwvT5RsPjpj/h3gCxuo3+WhkU4VwAA4I9hfn2iBvlGP4384hPSMUhYfvEJ3ghIVhbWGRruAvAxgJBtW0gUKu8s+AyVlSE5T4NsrLKyEu8u+Fw6BlF1suGboWET1gLgP7HouXC+B1F9Hc7OwfqtO6RjkEWs27odh7OPS8cgutpzoTr1rybhXgEAgH8C4APXZBlvfsQHVOhKb83n3wmylDPwzc6wCnsB0FTlAoDnw/0+RIFYt4Wf9uhah47lYMM2rgqRZTzvn51hFYkVAMBXAHinDYnaue8AXn77A+kYZFEvvfU+duw9IB2D6DQi9KE5IgVAUxUTwO8j8V5E1VmxbiP+8MKruFRaKh2FLOpSaSn+8OKrWL52g3QUcrff+2dm2HkidRiGbphNABwD0Coib0jk9/6ixfj4i6+kY5CNTJ94PebcOEU6BrnPSQDtIrH8D0SwAACAbphPIUx7GhNdLSevAJ8s+Qobt++SjkI2NKhPT8ydMQ3XaS2ko5B7PK2pSsSenIt0AWgM4CiAlIi9KbnK+QsXsXbzNqxYvwnH8wuk45DNRUdHY/SQgRg7bBAy09Pg8XikI5FzFQJor6nKpUi9YUQLAADohvkogL9F9E3JscorKpCbX4hjefnYd+gItu7ai/KKCulY5EBKYiK6d+mIjplt0C4jHW3SUtAoLk46FjnHY5qq/D2SbyhRAOIAHAaQEdE3Jtsrr6hAbkERsnPzcCw3H8dy85FfVMwd/UhEVFQUUpNaITMjHe3S09CuTRrapKUiLjZWOhrZTy6AjpqqlEXyTSNeAABAN8z7Abwc8Tcm26ioqERuYSGyc/Nx9HgesvPykVfIYU/W5isFrdEuIw3tMtKRmZGGNmkpLAVUlwc0VXkl0m8qVQBiABwA0D7ib06WU1FRibzCIv+n+jxk5+Yjt7CIw54cIToqCqnJrdEuIx3tMtKQmZGONqkpiI2NkY5G1nAUQBdNVSJ+7VKkAACAbph3AnhD5M1JTGVlJXILi5DtH/bHcvORV1iEigoOe3KP6KgopCUnITMjDe3a+C4hZKSlIDaGpcCF7tJU5U2JN5YsAFEAtgHoJRKAwq6yshJ5hcXIzvMv4+fmI7ewkMOeqBrR0dFIS07yXz7wrRRkpCazFDjbTgB9NVWpknhzsQIAALphjgawQiwAhUxlZSXyi4q/uzkvOzcPuQVFvCOfKAjR0dFIT0n67vJBu4x0pKckIyYmWjoahcYYTVVWSr25aAEAAN0wPwIwUzQE1UtlVZVv2Ps/1R/Ly0dufiGHPVEExMREIz05Ge3apCEzPR3t2qQhPZmlwIbma6pys2QAKxSATAD7ATQSDULVqqyqQkHRie+u12fn5uF4QSHKyznsiawiJiYaGSkpvnsKvlspSEJ0NEuBRZUCyNJUJVsyhHgBAADdMP8TwE+lc7hdVVUVCopPfPfY3bHjHPZEdhUbE4OM1GTfPgX+YpCWzFJgEb/TVOVn0iGsUgAS4dscKEk6i1v4hv3J7x67O5abh+P5hSgrL5eORkRhEhsTg4y0FP/GRb59CtKSkxAdFamT4QlAMXyb/pyXDmKJAgAAumHOA/Av6RxO9O2wz87Nw7G8fBw7no/cgkKUlkV00ykisqDY2Bi0SU25bKUgHanJrVkKwuceTVVekw4BWKsAeABsAtBfOoudeb1eFBSf8F+v//6TPYc9EQUqLjYWbdJSvtvNsF1GGlKTWiOKpSBYWwAM1FTFEoPXMgUAAHTDHAZgjXQOu/AN+5PIzvPdnHfseD5y8gs47Iko5HylIBXt2qR9dwkhpXUrloL6Ga6pylrpEN+yVAEAAN0w3wFwq3QOK7pwsQR7Dx3GgSPHcCw3Hzl5HPZEJKdRXNx3KwVZHdujW6cOaJIQLx3Lqt7VVOU26RCXs2IByIDvscAE6SzSKisrcSj7OHbvP4TdBw7iWG4+qqpENowiIqpTVFQUMjPS0LNLJ/To0gkdM9tyfwKfi/A99pcrHeRylisAAKAb5o8A/EE6h4SC4hPYfeAQdu8/hH2Hj+JSaal0JCKiBmkUF4esju3Rw18I0lNc+6DXv2uq8kfpEFezagGIBrARQD/pLOHm9Xqx7/BRrNm0Fbv2H8Rp46x0JCKisFCbKeiZ1RkjBvZDt04d4PF4pCNFwlYAgzRVsdwhKJYsAACgG2ZvAJsBOPIkjLPnzmHV+s1YsW4jir85JR2HiCiiWrfUMGboIIwaPABqM0U6TrhUABigqcoO6SDVsWwBAADdMP8LwE+kc4SK1+vFrv0HsXztBmzdvY/n3ROR60VHRaFP964YO2wwenXt7LSnCp7VVOUZ6RA1sXoBaAxgF4CO0lmCcdo4ixXrNmLl+k04dfqMdBwiIktqoTbD6CEDMWboILRs0Vw6TrAOA+ipqcol6SA1sXQBAL47Mng5ANtdLDp4LBsLlizDzn0Hefc+EVGAPB4PenTphOmTxiGrQzvpOA3hBTBW8qjfQFi+AACAbpgvA7hfOkeg8ouK8e7Cz7F1117pKEREtta7WxZuu2kqMlKTpaPUxyuaqjwgHaIudikAKoB9ACz9N0A/Y+CDT7/A6o1bYIf/XYmI7MDj8WD4gL645YZJuE5rIR2nLkUAumqqYkgHqYstCgAA6IY5E8BH0jmqc/7CBXyyZDmWrlqD8goenUtEFA4xMdEYP2Iopk8aByUxUTpOTW7WVGW+dIhA2KYAAIBumPMBzJDO8a3SsjIsXvE1Fn25HBdLLHufBxGRo8Q3boSp14/G1OtHoXGjRtJxLvexpiozpUMEym4FIAnAbgAtpbOsXL8J7y1aDOOsKR2FiMiVmjVtitnTJmHssMHSUQDgFIAemqoUSwcJlK0KAADohnkjgAVS72+Y5/DSW+9hx979UhGIiOgyvbp2wcN3zJHeUOgmTVUWSgaoL9sVAADQDfNFAA9F+n037diFl9/+EOcvXIj0WxMRUS0SmzTB/bfNwqA+PSXe/iVNVR6WeONg2LUAJADYBqBzJN6v5NIlvPb+x1i9cUsk3o6IiBpoxMB+mDd7JhLiG0fqLQ8C6KupysVIvWGo2LIAAIBumH0BbAAQG8732Xf4KF544x3u4EdEZBMtWzTHI3fdhq4d24f7rcoBDNZUZVu43ygcbFsAAEA3zB8DeDYcr11eUYH3Fi7G58tX8Zl+IiKb8Xg8mDJ2FObcOBmxMWE7U+4nmqr8PlwvHm52LwBRAL4CMCaUr5tfdAL/8883kFdom5s5iYioGukpSXji3ruQltw61C+9AsA4TVVsu8+7rQsAAOiGmQbfgUEhOTnieEEhfvs/L+Lced7oR0TkBE0Tm+DnTzyMNqkpoXrJM/Ad9JMfqheUYPtzF/3/B4TkiYCcvAL85r85/ImInOTc+Qv4zX+/iJy8glC95EN2H/6AAwoAAGiq8gGA14J5jYslJfjDi6/yET8iIgc6f+ECfv/CK7hwsSTYl3rNP3NszxEFwO8HABq8O8/rHy7AaeNsCOMQEZGVnDlr4vUPPg7mJfbDN2scwTEFQFOV8/CdE1DvvXl37juA1Rs2hz4UERFZytebtmLbnn0N+VITwAz/rHEExxQAANBU5SCAuwHU687GBUuWhScQERFZzsIly+v7JV4Ad/tnjGM4qgAAgKYqnwD4r0D/fEHxCew/ciyMiYiIyEoOHsuu72Pe/+WfLY7iuALg9wsASwP5g8vXbghzFCIispp6/OxfCt9McRxHFgD/xgy3Azhe15/lp38iIvc5cDSgn/3HAdxu581+auPIAgAAmqroAGYCuFTTn6mqqkJ+EXf7IyJym4KiE6isqnWuXwIw0z9LHMmxBQAA/Ac0PFLTf1544huUl1dEMBEREVlBeUUFik6crO2PPGLXQ34C5egCAACaqrwG4IXq/jNu+kNE5F7nL9R4gu8L/tnhaI4vAH5PAlh/9b8ZHR0tEIWIiKyghhmwHr6Z4XiuKACaqpTBt0lQzuX/fgwLABGRa1UzA3Lg2+ynLPJpIs8VBQAANFU5AWAKAOPbf69pYhO5QEREJOqqGWAAmOKfFa7gmgIAAJqq7IfvyYByAGjZojnUZopsKCIiirjmzRS0bPHdKfLl8N3x3+DzZOzIVQUAADRVWQHg/m//dafMtmJZiIhIRqd2bS//l/f7Z4OruK4AAICmKm8A+DUA9MzqJJyGiIgirWdW529/+2v/THAdVxYAANBU5VcA3hwxqD+UxETpOEREFCFNE5tg+MB+APCmfxa4kmsLgN/9cbGxKyeOHi6dg4iIImTCyGGIi41dicsuB7uRqwvAt48HThg57FBz3gxIROR4StNEjB8x9BBc9LhfTVxdAABAUxUjsUnCpIfvvNXweDzScYiIKEw8Hg8evuNWo5nSdJKmKkbdX+Fsri8AAKCpSnbPrM7jpo0bXSqdhYiIwuOGcaNL+3TPGqepSrZ0FitgAfDTVGXrjMnjJwzs3bNSOgsREYXWwN49K2dOHj9BU5Wt0lmsggXgMqmtr1v94NxbpvXpnuXIs5+JiNyoT/esqgfn3jIttfV1q6WzWAkLwFUyUpIWPzh3zq3dOnf0SmchIqLgdOvc0fvg3Dm3ZqQkLZbOYjUsANVon5H6wSN33nrvVTtFERGRjXRq1xaP3Hnrve0zUj+QzmJFLAA16JSZ8dqjd9/+RGZ6mnQUIiKqp8z0NDx69+1PdMrMeE06i1WxANSia4fMvzx+z9xfpCUnSUchIqIApSUn4fF75v6ia4fMv0hnsTIWgDr06Nzht0/ce8ezSa1aSkchIqI6JLVqiSfuvePZHp07/FY6i9WxAASgd9fOzzxxz50vXnZ0JBERWUzLFs3xxD13vti7a+dnpLPYAQtAgPr37PrI4/Pmvqxyy2AiIstRmyl4fN7cl/v37PqIdBa7YAGoh6H9ej340NzZf1Ga8vRAIiKrUJom4qG5s/8ytF+vB6Wz2InH6+Xj7vW1bN2m37769oc/O3XmjHQUIiJX05qruO+2Wb8bN2zQz6Sz2A0LQAOt2bz9xy+//cGzRSe/kY5CRORKra9riftvm/XMqEH9npXOYkcsAEHYuGPPQ6+888ELx/MLeYwgEVEEpacke++/bdZjQ/r2fEE6i12xAARp5/5Dt7389gdvHTqWw/spiIgioH2bjKoHbr/lrr7du/yvdBY7YwEIgf1Hcm549d0PP9m1/2C0dBYiIifL6ti+8v7bZs3s0bnDQuksdscCECI5+UWjX3nng6WbduyOlc5CROREvbtlVdx3680TO7drs1w6ixOwAIRQ0Ul9wKvvfrhq9cYt8dJZiIicZFCfnpfuv+2WUW1SkzZJZ3EKFoAQ0w0z89V3P9ry1dfrWkhnISJyguED+hn3zJnZPz251VHpLE7CAhAGumGqb81fuO2zZasypbMQEdnZmKGDch+cO7uXpiqGdBanYQEIE90w4xZ9uWLZB59+Mby8okI6DhGRrURHReHGCWM3zp42eaSmKmXSeZyIBSDMPl6y/NX/nb/oXvP8eekoRES2kBAfjznTJr95202T75LO4mQsABGwbO3GH741f9EfCopPcMMgIqJatG6peW+9aepPp44dwd39wowFIEK27N53w//OX/Tx3kNHYqSzEBFZUad2bSvm3DjllhED+nwincUNWAAi6FheQfd3Pvls3aoNm5tKZyEispLBfXufv2361GFZ7dvuks7iFiwAEaYbZusPP1uyYf7iL9vyf3sicjuPx4Mbrh+de/uMGwZqqnJCOo+bsAAI0A0zbunqtR+/88lnUy6VlkrHISISERcbi9nTJi2Zev3oG3mnf+SxAAia/8WyX76/6ItfnzYM3hxIRK6iKk29N0+d+H/n3DDxV9JZ3IoFQNiir1aN/2Ll1wsPZx9vLJ2FiCgS2mWklY4fMWzGzVPGLZbO4mYsABaw73B2qwVLl21YuX5TJv//ICInGzl4QM6EEUOHDOzdvVg6i9uxAFiEbphRny9f/e7Hi7+85fzFi9JxiIhCKiE+HtMnXv/htPFj5miqUiWdh1gALOfLNRse+OjzpS8cO54XLZ2FiCgUMtNTK6dPGv/Y5NHDXpLOQt9jAbCgQ9m53eYvXrp6+dqNPFGQiGxt9JCBZ6ZPGjeya4fMPdJZ6EosABalG2bi4hWrF37w6ZIxJZcuScchIqqX+MaNMWvqhJVTxo6apqkKD0OxIBYAi/t8xdc/mL/4y+dyC4p4SYCIbCE9Jbly5uRxT08dO/J/pLNQzVgAbGD9tl3tP1++avXG7btSpLMQEdVmUJ+ehVM6SxiYAAAKDUlEQVTGjho5pG/Po9JZqHYsADahG2bUuws+f3PZmvW38ykBIrKaxIQEXD98yNu33jTlTt7lbw8sADaz4MuVE1at3/TRnoOHE6WzEBEBQPfOHS+MGjJw5k3jRy+VzkKBYwGwId0wEz749IvPF6/4ehRvECQiKfGNG2HS6BGrZk+bPEVTFS5N2gwLgI0t/Xr9fZ8tW/XC/sNHY6WzEJG7dOnQrnzq9aMenThy6CvSWahhWABsrvDkqeQFS5Yt/nz56l6lZTxMi4jCKy42FpPHjtw1Y9K4SSmtWhZJ56GGYwFwiM+Wr370s2WrnjuSkxsnnYWInCkzI6186thRT984fvRfpbNQ8FgAHORQdm6LhUuXL16xbuPA8ooK6ThE5BAx0dEYNWTg5sljRk7u2aWDLp2HQoMFwIHemv/p3as2bn7xeH4hjxgmoqCkpySVDh/Q79F7Zk//p3QWCi0WAIfavGtfwtrN2+av3rB5IvcNIKL6SoiPx4iB/b4cOXjA9AE9u/KHiAOxADjcktXrRq/dvO2Djdt3teT/10QUiAG9euhD+/eZPXXsiOXSWSh8WABcQDfM6BXrNj7/xco1j+YWFEZJ5yEia0pLTqqaOGrYi+NGDH1CU5VK6TwUXiwALnIstyDz8xWrP/zq63V9L5ZwAyEi8olv3Ahjhw3ePmn0iFmd27U5Jp2HIoMFwIWWrF43bdX6zf/asmuPJp2FiGT16ZZ1etSQgfdOGTN8gXQWiiwWAJfSDdOz8Mvl/7lq/eYfFZ44GSOdh4giq/V1LStGDe7/3IxJ43+iqQoHgQuxALjc15u2qWu3bP9w4/Zd11/g0wJEjpcQH48Bvbqv6NWty6wbxo48LZ2H5LAAEADg02Wre+3cd+C99Vt3dC4rL5eOQ0QhFhsbg0F9eh3u0aXTnBkTx26XzkPyWADoCktWr7t5/ZYd/9iwfWeLqioe6U1kd1FRURjYu+fpwX17PTxlzPAPpPOQdbAA0DV0w4zasG3Hj1Zt2Px/duw90EQ6DxE1TK+unS+MGDTgN8P69/m9pips9HQFFgCqkW6YMUtXr/2/azZtffpw9vFG0nmIKDAd2rYpHTag73OTRg//paYqPBiEqsUCQHXSDTPuw8+WPL9h2877C4pPxErnIaLqpSS1qhjSt/fLs6ZOfFJTFZ4PTrViAaCAbd61L+HrjVte3rprz5xvTp+Jls5DRD7XtWhe2bdnt/dHDhpwP/ftp0CxAFC9bdyxR9m8Y/eL2/bsm51fVMwiQCQkLbl1ZZ/uXT8Y2LvnQ4N6dzel85C9sABQg+mGqXz61Yq/b9qxe87h7OPcTIgoQjq0zagY2Lvne2OHDX4sI6X1Wek8ZE8sABQ03TCbLFm15rebd+x+YO+hIwnSeYicqmvH9iX9e/V4efKYET/TVOWCdB6yNxYAChndMKO/XL3uqW179j2za/9BjfsIEAXP4/GgZ1bn0326Zz07cdTwP/GUPgoVFgAKi3cXfXHrrn0Hf7dz34G25RV8ComovqKjo9Gra+fjPbt0/unt06e8I52HnIcFgMLqrY8/HXYsN/+/dx841Pesec4jnYfI6pTERG/3Lh13tE1P/bd5s276WjoPORcLAEXE5l17k7ft3vf8noOHpx88mh0nnYfIajq1a1verVOHBb26dvm3of16FUrnIedjAaCI0g0z9uuNWx7duf/g09v37Mu4WHJJOhKRmPjGjdGne1Zez6zOfx41eMDfNFXhSVwUMSwAJGbtlh1dN+/c8/s9Bw9NyC0o4g6D5BrpKcnlPbp0/LJvj24/Hjmw717pPOROLAAkTjfM6IVLlz954OixJ/ccPJxWXs6bBsl5YmNj0L1zx/zO7TL/+6aJ1z/Hu/lJGgsAWcp7i77onpNf+Gx2bv71x3LzeAAR2V67jPTSzIy0ZW3TUn4yZ9qkPdJ5iL7FAkCWpBtm1Lqt2+86cCT7qX2HjnQvKD4RJZ2JKFCpSa2runbqsKdLh8znhvbr8waP4iUrYgEgy9MNM37ZmvWPHDqW88DeQ0c662cMPk5IlqM1V73dOnU42Kld25evHz7kBU1VSqQzEdWGBYBsJTu/MHHF2o0/PJqbd/f+w0fbnr9wkWWAxCQ2SfBmdWyf0z4j/fUxwwb9KTMt5bx0JqJAsQCQbS1ft6nF3kNHfppbUHTr0ZzctPMXeQoqhV9iQgLat83Iz0hNfrdbpw6/Gzt04GnpTEQNwQJAjrBz/6EWO/Yd+GF+YfHNR4/ndcwvKuY9AxQyaclJVe3bpB9OS0n6qHfXLn/qldWJQ59sjwWAHEc3zJi1m7fNOJKTe29uYdHQI9nHlbJy7q9CgYuLjUWHzDZmRkryug5tM/45bEDfjzVV4fOp5CgsAOR4y9dtbnvgyNEfFBSfnHYsN6+9fsbg6gBdQ2uuVrXLSD+amtRqUZcO7f8yduiAHOlMROHEAkCuohtm1MeLv7z1pH767lOnzwzIyS9ofv4C7x1wo8QmCWiblnqmZYvmm1tpLV6fMXn8u3xcj9yEBYBcLbfwRLN1W7bPLjxx8qYTp071zy0oasXHDJ1Ja656M1KTT7Zu2XJLSutWC4b27/N+Rkrrs9K5iKSwABBdRjfMmBXrNk7OLyqefVI/PbSg+ERG8clTMfw+sRePx4OkVi0rUpNa57bSWqxLS056f8zQQYt5HZ/oeywARHX4eMnyfrkFRXcapjnqzFmzfdH/b+/eWpuIggAAZ8/Zs7dkL02ahG1KAxWr4KW1CKkKKr5U8cnf6E/wRX1roeKFCrbkJdpgbGo1Ye/Jyd7Oxof8AFEMacx8MO/DgRlmYOD0+qrjwuJ4kRialluploMlQz8xNG1vrWY+f7b76HDWeQFwkcEAAMAfslxfODxu7nS63584ntewHe9Kz7LLP/p9kqbwv8s0IYRy1eVSWlku9YuG3ioa+ruaWX15Z3vroGRo8azzA2CewAAAwD/y4ahpNltfntqO99D1/U3L8db6tq16fgB19hfyijwuF4vD0pJxamjqkaFre/XVlRePH9zrzjo3AP4H0JgAmCLL9VGr/XWj3TlteEGwFQzp1QGl9SAYVFw/0CzHJVG8mIsrIXyuZBiprqmBVsj38oryTZHlVkGRP5nVytud7c0mXOUDMD0wAAAwQ5brC6/3D245nt8YUnqD0nCDhmEtiiKdhqE8GoXigFJMR+Hc1CrHcTlFlsYFRWGyLEWKJI1EUfQUSTqTZemzIkvHaiH//vbN6x+vXV6PZp0vAItqbpoKAIvs1f4b9ez856UwitbjJKnHcbIaJ4kZJ0kljpNilCQ6Y0zMsowwxnCWZTxjGWZZhhhjmDGG0klwjDEuTRmXssm9Ao9xjufxGGM85ieR4UkwjFCGMWIIoRRjzBBCCcY4EgnxBIHYAiE9gZBzQSBdgZCOJIrtmlk92b1/N5jxkwEAfuMXGoBkLGH1BvcAAAAASUVORK5CYII='))
                      : MemoryImage(base64Decode(
                          boughtFlower.flowerListViewModel.vendorUser.image)),
                ),
              ),
              child: const SizedBox(
                width: 30.0,
                height: 30.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _description() {
    return Row(
      children: [
        Text(LocaleKeys.customer_home_item_description.tr,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(
          boughtFlower.flowerListViewModel.shortDescription,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _name() {
    return Row(
      children: [
        Text(
          LocaleKeys.customer_home_item_name.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          boughtFlower.flowerListViewModel.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  BoxDecoration _imageFlower() {
    return _showImage();
  }

  BoxDecoration _showImage(){
    if(boughtFlower.flowerListViewModel.image == ''){
      return BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 6),
            blurRadius: 6.0,
          )
        ],
      );
    }
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0xff04927c),
          offset: Offset(0, 6),
          blurRadius: 6.0,
        )
      ],
      image: DecorationImage(
        image: MemoryImage(base64Decode(boughtFlower.flowerListViewModel.image)),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _editFlowerCountBuyCartPlusLoading(
      {required BoughtFlowersViewModel boughtFlowers}) {
    if (controller
        .isLoadingPlusCart[boughtFlowers.flowerListViewModel.id]!.value) {
      return const CircularProgressIndicator();
    }
    return IconButton(
      onPressed: () {
        controller.editFlowerCountBuyCartPlus(boughtFlowers: boughtFlower);
      },
      icon: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget _editFlowerCountBuyCartMinusLoading(
      {required BoughtFlowersViewModel boughtFlowers}) {
    if (controller
        .isLoadingMinusCart[boughtFlowers.flowerListViewModel.id]!.value) {
      return const CircularProgressIndicator();
    }
    return IconButton(
      onPressed: () {
        controller.editFlowerCountBuyCartMinus(boughtFlowers: boughtFlower);
      },
      icon: const Icon(
        Icons.remove,
        color: Colors.white,
      ),
    );
  }

  Widget _deleteCartBtn({required BoughtFlowersViewModel boughtFlowers}) {
    if (controller
        .isLoadingDeleteButton[boughtFlowers.flowerListViewModel.id]!.value) {
      return const CircularProgressIndicator();
    }
    return DeleteAlertDialog(
      flowerItem: boughtFlower.flowerListViewModel,
      boughtFlowers: boughtFlower,
    );
  }
}
