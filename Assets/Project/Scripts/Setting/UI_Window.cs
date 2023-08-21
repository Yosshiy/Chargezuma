using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UI_Window : MonoBehaviour
{
    [SerializeField] Image UIWindow;
    Vector3 Scale;

    private void Awake()
    {
        UIWindow.gameObject.SetActive(false);
        Scale = UIWindow.rectTransform.localScale;
        UIWindow.rectTransform.localScale *= 0.9f;
    }

    public void WindowOpen()
    {
        DOTween.Sequence()
               .AppendCallback(() =>
               {
                   UIWindow.gameObject.SetActive(true);
               })
               .Append(UIWindow.rectTransform.DOScale(Scale, 0.1f).SetEase(Ease.InQuad));
               
    }

    public void WindowClose()
    {
        var next = UIWindow.rectTransform.localScale * 0.9f;

        DOTween.Sequence()
               .Append(UIWindow.rectTransform.DOScale(next, 0.1f))
               .AppendCallback(() =>
               {
                   UIWindow.gameObject.SetActive(false);
               });   
    }
}
